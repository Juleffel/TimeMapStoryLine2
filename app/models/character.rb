class Character < ActiveRecord::Base
  extend HashBy
    
  belongs_to :user, inverse_of: :characters
  belongs_to :group, inverse_of: :characters
  belongs_to :faction, inverse_of: :characters
  belongs_to :topic, inverse_of: :character, dependent: :destroy # Character sheet topic
  belongs_to :links_topic, class_name: "Topic", inverse_of: :links_character, dependent: :destroy # Character sheet topic
  belongs_to :rps_topic, class_name: "Topic", inverse_of: :rps_character, dependent: :destroy # Character sheet topic
  
  has_many :to_links, foreign_key: :from_character_id, inverse_of: :from_character, class_name: "Link", dependent: :destroy
  has_many :to_links_characters, through: :to_links, class_name: "Character", source: :to_character
  has_many :from_links, foreign_key: :to_character_id, inverse_of: :to_character, class_name: "Link", dependent: :destroy
  has_many :from_links_characters, through: :from_links, class_name: "Character", source: :from_character
  
  has_many :presences, inverse_of: :character, dependent: :destroy
  has_many :spacetime_positions, through: :presences, inverse_of: :characters
  has_many :answers, inverse_of: :character
  
  validates :avatar_url, format: { with: /\A(https?:\/\/.*|)\z/,
      message: "must be like 'http://...'" }
  validates :image_url, format: { with: /\A(https?:\/\/.*|)\z/,
      message: "must be like 'http://...'" }
  validates :small_image_url, format: { with: /\A(https?:\/\/.*|)\z/,
      message: "must be like 'http://...'" }
  
  #validates_inclusion_of :sex, :in => %w( m f )
  
  default_scope -> { order(:id) }
  
  after_create -> do
    create_own_topic
    update_birth_spacetime_position
  end
  after_update -> { update_birth_spacetime_position }
  
  RAND = Random.new(1234)
  
  def links
    from_links.order(:force) + to_links.order(:force)
  end
  def number_of_messages
    @number_of_messages = @number_of_messages || Character.all.joins(:answers).select(:id, 'COUNT(answers.id) AS c').group('characters.id').where(id: self.id).first.c
  end
  
  def generate_rp_topics
    unless @user_rp_topics
      topic_includes = [:user, {answers: :character}, :category]
      user_rpg_topic_ids = Topic.select(:id).joins(:category).where(user_id: self.user_id, 'categories.is_rpg' => true).map(&:id).uniq
      user_rpg_topic_with_answers_ids = Topic.select(:id).joins(:answers).where(id: user_rpg_topic_ids).map(&:id).uniq
      user_rpg_topic_with_character_answers_ids = Topic.select(:id).joins(:answers).where(id: user_rpg_topic_ids, 'answers.character_id' => self.id).map(&:id).uniq
      user_rpg_topic_without_answers_ids = user_rpg_topic_ids - user_rpg_topic_with_answers_ids
      
      @user_rp_topics = Topic.includes(topic_includes).where(id: user_rpg_topic_without_answers_ids)
      @character_rp_topics = Topic.includes(topic_includes).where(id: user_rpg_topic_with_character_answers_ids)
    end
  end
  def user_rp_topics
    generate_rp_topics
    @user_rp_topics
  end
  def character_rp_topics
    generate_rp_topics
    @character_rp_topics
  end
  
  def update_birth_spacetime_position
    sp = self.spacetime_positions.where(birth: true).first || self.spacetime_positions.new
    sp.birth = true
    sp.latitude ||= 33.45772 + RAND.rand(-1.00..1.00)
    sp.longitude ||= -89.802246 + RAND.rand(-1.00..1.00)
    sp.title = "Naissance de "+complete_name
    sp.subtitle = shortline1
    sp.resume = quote
    sp.begin_at = birth_date.to_datetime || (DateTime.now - 25.years)
    sp.topic_id = topic_id
    sp.user_id = user_id
    sp.save
  end
  def self.update_birth_spacetime_positions
    all.each do |c|
      c.update_birth_spacetime_position
    end
  end
  
  # "Toto Madrillano Q. sueño" => "T. M. Q. S."
  def contracted_middle_name
    ((middle_name || '').split(' ').map {|s| s[0].capitalize + "."}).join(" ")
  end
  # "Michel Jean Marc Corones" => "Michel Jean Marc Corones"
  def complete_name
    [first_name, middle_name, last_name].delete_if {|e| e.blank?}.join(' ')
  end
  # "Michel Jean Marc Corones" => "Michel J. M. Corones"
  def contracted_name
    [first_name, contracted_middle_name, last_name].delete_if {|e| e.blank?}.join(' ')
  end
  def name
    contracted_name
  end
  def to_s
    name
  end
  
  def create_own_topic
    Topic.skip_callback(:create)
    unless self.topic
      self.topic = Topic.new(user_id: self.user_id, image_url: self.image_url, title: self.name, subtitle: self.quote, summary: self.summary)
      self.topic.save(:validate => false)
    end
    unless self.links_topic
      self.links_topic = Topic.new(user_id: self.user_id, image_url: self.image_url, title: self.name, subtitle: self.quote, summary: self.summary)
      self.links_topic.save(:validate => false)
    end
    unless self.rps_topic
      self.rps_topic = Topic.new(user_id: self.user_id, image_url: self.image_url, title: self.name, subtitle: self.quote, summary: self.summary)
      self.rps_topic.save(:validate => false)
    end
    Topic.set_callback(:create)
    self.save
  end
  
  def self.last_update
    [self.maximum(:updated_at), self.maximum(:map_nodes_updated_at)].max
  end
  
  def json_attributes
    attributes.merge({
      node_ids: spacetime_position_ids,
      to_link_ids: to_link_ids, 
      name: to_s,
      importance: 1,
      depth: 0,
    })
  end
end
