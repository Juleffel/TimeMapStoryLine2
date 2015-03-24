class Group < ActiveRecord::Base
  extend HashBy
  
  has_many :characters, inverse_of: :group
  
  validates :color, format: { with: /\A#[0-9a-fA-F]{3}[0-9a-fA-F]{3}?\z/,
    message: "Must be like #1A6F20" }
  
  def to_s
    name
  end
  
  def json_attributes
    attributes.merge({"node_ids" => self.character_ids})
  end
end
