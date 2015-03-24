class Character < ActiveRecord::Base
  extend HashBy
    
  belongs_to :user, inverse_of: :characters
  belongs_to :topic, inverse_of: :character, dependent: :destroy
  belongs_to :group, inverse_of: :characters
  belongs_to :faction, inverse_of: :characters
  
  has_many :to_links, foreign_key: :from_character_id, inverse_of: :from_character, class_name: "Link", dependent: :destroy
  has_many :to_links_characters, through: :to_links, class_name: "Character", source: :to_character
  has_many :from_links, foreign_key: :to_character_id, inverse_of: :to_character, class_name: "Link", dependent: :destroy
  has_many :from_links_characters, through: :from_links, class_name: "Character", source: :from_character
  
  has_many :presences, inverse_of: :character, dependent: :destroy
  has_many :spacetime_positions, through: :presences
  has_many :answers, inverse_of: :character
  
  validates :avatar_url, format: { with: /\Ahttps?:\/\//,
      message: "must be like 'http://...'" }
  validates :image_url, format: { with: /\Ahttps?:\/\//,
      message: "must be like 'http://...'" }
  
  #validates_inclusion_of :sex, :in => %w( m f )
  
  default_scope -> { order(:id) }
  
  after_create -> { create_own_topic }
  
  def links
    from_links.order(:force) + to_links.order(:force)
  end
  
  # "Toto Madrillano Q. sueño" => "T. M. Q. S."
  def contracted_middle_name
    ((middle_name || '').split(' ').map {|s| s[0].capitalize + "."}).join(" ")
  end
  # "Michel Jean Marc Corones" => "Michel Jean Marc Corones"
  def complete_name
    [first_name, middle_name, last_name].compact.join(' ')
  end
  # "Michel Jean Marc Corones" => "Michel J. M. Corones"
  def contracted_name
    [first_name, contracted_middle_name, last_name].compact.join(' ')
  end
  def name
    contracted_name
  end
  def to_s
    name
  end
  
  def create_own_topic
    self.topic = Topic.create(user_id: self.user_id)
    self.save
  end
  
  def nodes_updated_at
    spacetime_positions.maximum(:updated_at)
  end
  
  def json_attributes
    attributes.merge({
      node_ids: spacetime_positions.order(:begin_at).map(&:id), 
      nodes_updated_at: nodes_updated_at, 
      to_link_ids: to_link_ids, 
      name: to_s,
      importance: 1,
      depth: 0,
    })
  end
end
