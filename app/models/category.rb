class Category < ActiveRecord::Base
  belongs_to :category, inverse_of: :categories
  has_many :categories, inverse_of: :category, :dependent => :destroy
  has_many :topics, inverse_of: :category, :dependent => :destroy
  
  validates :image_url, format: { with: /\A(https?:\/\/.*|)\z/,
    message: "Must be like 'http://...'" }
  
  scope :roots, -> { where(category_id: nil) }
  default_scope {order(:num)}
  
  PERMISSION_LEVELS = [
      ["Visiteurs", "visitors"],
      ["Membres", "members"],
      ["Modérateurs", "moderators"],
      ["Admins", "admins"]
      ]
  
  SPECIALS_HASH = { # SYMBOL -> [TXT, STR]
    valid: ["valid", "Personnages validés"],
    no_valid: ["no-valid", "En attente de validation"],
    dead: ["dead", "Décédés/Abandonnés"],
    npc: ["npc", "Postes vacants"],
  }
  SPECIALS_STR = Hash[SPECIALS_HASH.map{|k,v| [v[0],[k, v[1]]] } ] # STR -> [SYMB, TXT]
  SPECIALS = SPECIALS_HASH.map{|k,v| [v[1],v[0]] } # [TXT, STR]
  
  def self.special_symb_to_str(symb) # take SYMB or STR, return STR
    if symb.is_a? String and SPECIALS_STR[symb]
      symb
    elsif symb.is_a? Symbol and SPECIALS_HASH[symb]
      SPECIALS_HASH[symb][0]
    end
  end
  def self.special_str_to_txt(symb) # take SYMB or STR, return TXT
    if symb.is_a? String and SPECIALS_STR[symb]
      SPECIALS_STR[symb][1]
    elsif symb.is_a? Symbol and SPECIALS_HASH[symb]
      SPECIALS_HASH[symb][1]
    end
  end
  def self.special_str_to_symb(symb) # take SYMB or STR, return SYMB
    if symb.is_a? String and SPECIALS_STR[symb]
      SPECIALS_STR[symb][0]
    elsif symb.is_a? Symbol and SPECIALS_HASH[symb]
      symb
    end
  end
  def self.specials(symb) # take SYMB or STR
    # find_by_special take STR
    self.find_by_special(self.special_symb_to_str(symb))
  end
  def special_str
    special
  end
  def special_symb
    Category.special_str_to_symb(special)
  end
  def special_txt
    Category.special_str_to_txt(special)
  end
  
  def supcategories
    cat = self.category
    supcats = []
    while cat and cat != self # Stupid guy, I will fucking kill you. (loop)
      supcats << cat
      cat = cat.category
    end
    supcats.reverse
  end
  def supcategory_ids
    self.supcategories.map(&:id)
  end
  
  def subcategories
    cats = self.categories
    subcats = []
    cat = nil
    while cats.length and cat != self # Stupid guy, I will fucking kill you. (loop)
      cat = cats.pop
      subcats << cat
      cats << cat.categories
    end
    subcats
  end
  def subcategory_ids
    self.subcategories.map(&:id)
  end
  
  def special_topics
    p special
    @special_topics = @special_topics || if Group.specials(special)
      special_groups = Group.specials(special).includes(characters: {topic: [:user, {answers: {character: :faction}}]})
      characters = special_groups.map(&:characters).flatten.compact
      characters.map(&:topic).compact
    end || []
  end
  def _topics
    @_topics = @_topics || [topics, @special_topics].flatten.compact
  end
end
