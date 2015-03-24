class SpacetimePosition < ActiveRecord::Base
  belongs_to :topic, inverse_of: :spacetime_position
  has_many :presences, inverse_of: :spacetime_position
  has_many :characters, through: :presences
  
  default_scope -> {order(:begin_at)}
  def end_at
    @end_at || (begin_at + 3.hours if begin_at)
  end
  
  def json_attributes
    attributes.merge({character_ids: character_ids, end_at: end_at})
  end
  
  def self.hash_by(key)
    hash = {}
    self.all.each do |obj|
      hash[obj.send(key)] = obj.json_attributes
    end
    hash
  end
  
  after_save -> { characters.each(&:touch) }
  before_destroy -> { characters.each(&:touch) }
end
