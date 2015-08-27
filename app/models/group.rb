class Group < ActiveRecord::Base
  extend HashBy
  
  has_many :characters, inverse_of: :group
  
  validates :color, format: { with: /\A#[0-9a-fA-F]{3}[0-9a-fA-F]{3}?\z/,
    message: "Must be like #1A6F20" }
  SPECIALS = Category::SPECIALS_HASH.map{|k,v| [v[1],v[0]] if v[2] == :character}.compact # [TXT, STR]
  scope :specials, ->(symb) { where(special: Category.special_to_str(symb)) }
  default_scope { order(:id) }
  
  def to_s
    name
  end
  
  def json_attributes
    attributes.merge({"node_ids" => self.character_ids})
  end
  
  def special_str
    special
  end
  def special_symb
    Category.special_to_symb(special)
  end
  def special_txt
    Category.special_to_txt(special)
  end
end
