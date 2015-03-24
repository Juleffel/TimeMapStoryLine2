class Link < ActiveRecord::Base
  extend HashBy
  
  belongs_to :from_character, class_name: "Character", inverse_of: :to_links
  belongs_to :to_character, class_name: "Character", inverse_of: :from_links
  belongs_to :link_nature, inverse_of: :links
  
  validates_uniqueness_of :to_character_id, scope: :from_character_id # Prevent two links to be created between the same two characters
  
  def json_attributes
    attributes.merge(
      node_from_id: from_character_id, 
      node_to_id: to_character_id,
      strengh: force.abs,
      label: title)
  end
end
