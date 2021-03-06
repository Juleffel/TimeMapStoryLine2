class Category < ActiveRecord::Base
  belongs_to :category, inverse_of: :categories
  has_many :categories, inverse_of: :category, :dependent => :destroy
  has_many :topics, inverse_of: :category#, :dependent => :destroy

  validates :image_url, format: { with: /\A(https?:\/\/.*|)\z/,
    message: "Must be like 'http://...'" }

  scope :roots, -> { where(category_id: nil) }
  scope :rpg, -> { where(is_rpg: true) }
  scope :flood, -> { where(is_flood: true) }
  default_scope {order(:num)}

  PERMISSION_LEVELS = [
      ["Visiteurs", "visitors"],
      ["Membres", "members"],
      ["Modérateurs", "moderators"],
      ["Admins", "admins"]
      ]

  SPECIALS_HASH = { # SYMBOL -> [TXT, STR, ROLE]
    valid: ["valid", "Personnages validés", :character],
    no_valid: ["no-valid", "En attente de validation", :character],
    dead: ["dead", "Décédés/Abandonnés", :character],
    npc: ["npc", "Postes vacants", :character],
    links: ["links", "Liens des personnages", :links],
    rps: ["rps", "RPs des personnages", :rps],
  }
  SPECIALS_STR = Hash[SPECIALS_HASH.map{|k,v| [v[0],k] } ] # STR -> SYMB

  SPECIALS_ROLE = {} # ROLE -> [SYMBS]
  SPECIALS_HASH.each do |k, v|
    SPECIALS_ROLE[v[2]] = (SPECIALS_ROLE[v[2]] || []).push(k)
  end
  SPECIALS = SPECIALS_HASH.map{|k,v| [v[1],v[0]] } # [TXT, STR]

  #######
  # Special Conversion
  #######
  # Take SYMB or STR, return SYMB
  def self.special_to_symb(symb) # t
    if symb.is_a? String and SPECIALS_STR[symb]
      SPECIALS_STR[symb]
    elsif symb.is_a? Symbol and SPECIALS_HASH[symb]
      symb
    end
  end
  # Take ROLE, return SYMB
  def self.special_role_to_symbs(role)
    SPECIALS_ROLE[role]
  end
  # Take ROLE, return SYMB
  def self.special_role_to_symb(role)
    self.special_role_to_symbs(role).first
  end
  # Take SYMB or STR, return STR
  def self.special_to_str(symb)
    if symb = self.special_to_symb(symb) # -> SYMB or STR -> SYMB
      SPECIALS_HASH[symb][0] # -> STR
    end
  end
  # Take SYMB or STR, return STR
  def self.special_to_txt(symb)
    if symb = self.special_to_symb(symb) # -> SYMB or STR -> SYMB
      SPECIALS_HASH[symb][1] # -> TXT
    end
  end
  # Take SYMB or STR, return STR
  def self.special_to_role(symb)
    if symb = self.special_to_symb(symb) # -> SYMB or STR -> SYMB
      SPECIALS_HASH[symb][2] # -> ROLE
    end
  end

  #######
  # Search a special Category
  #######
  # Take SYMB or STR, return Category
  def self.specials(symb)
    # find_by_special take STR
    if str = self.special_to_str(symb) # -> SYMB or STR -> STR
      self.find_by_special(str)
    end
  end
  # Return the category for a particular role (if it exists)
  # The role must be in SPECIALS_HASH and must be unique
  def self.special_role(role)
    if symb = self.special_role_to_symb(role) # ROLE -> SYMB
      self.specials(symb)
    end
  end
  # Return the categories for a particular role (if it exists)
  # The role must be in SPECIALS_HASH and can be in multiple lines
  def self.specials_role(role)
    if symbs = self.special_role_to_symbs(role) # ROLE -> SYMB
      symbs.map {|symb| self.specials(symb)}
    end
  end

  #######
  # Special attributes
  #######
  def special_str
    special
  end
  def special_symb
    Category.special_to_symb(special)
  end
  def special_txt
    Category.special_to_txt(special)
  end
  def special_role
    Category.special_to_role(special)
  end

  #######
  # Special Topics
  #######
  # If current category is special, return its topics
  def special_topics(topics_includes = [])
    @special_topics ||= (if special
      if special_role == :character and Group.specials(special)
        special_groups = Group.specials(special).includes(characters: {topic: topics_includes})
        characters = special_groups.map(&:characters).flatten.compact
        characters.map(&:topic).compact
      elsif special_role == :links
        characters = Character.not_npc.all.includes({links_topic: topics_includes})
        characters.map(&:links_topic).compact
      elsif special_role == :rps
        characters = Character.not_npc.all.includes({rps_topic: topics_includes})
        characters.map(&:rps_topic).compact
      end
    end || [])
  end
  def _topics
    @_topics ||= [topics, @special_topics].flatten.compact
  end

  #######
  # SuP-Categories
  #######
  def supcategories
    @supcategories ||= (
      cat = self.category
      supcats = []
      while cat and cat != self # Stupid guy, I will fucking kill you. (loop)
        supcats << cat
        cat = cat.category
      end
      supcats.reverse
    )
  end
  def supcategory_ids
    self.supcategories.map(&:id)
  end

  #######
  # SuB-Categories
  #######
  def subcategories
    @subcategories ||= (
      cats = categories.to_a
      subcats = []
      cat = nil
      while not cats.empty? and cat != self # Stupid guy, I will fucking kill you. (loop) (do a warniiiing!)
        cat = cats.pop
        subcats << cat
        cats += cat.categories.to_a
      end
      subcats
    )
  end
  def subcategory_ids
    subcategories.map(&:id)
  end

  #######
  # SuB-Topics (topics in this category and all its sub-categories)
  #######
  def subtopics
    @subtopics ||= (
      subcats = subcategories
      subcat_ids = subcategories.map(&:id)
      res = Topic.all.includes(:answers).where(category_id: [self.id]+subcat_ids)
      # Add special topics
      ([self]+subcats).each do |cat|
        res += cat.special_topics(:answers)
      end
      Topic.order_topics(res)
    )
  end

  #######
  # Last sub-topic (last answered topic in all subtopics)
  #######
  def last_subtopic
    subtopics.first # topics are in a reverse order (last is first)
  end
end
