class Presence < ActiveRecord::Base
  belongs_to :spacetime_position, inverse_of: :presences
  belongs_to :character, inverse_of: :presences
  
  after_save -> { character.update_column(:map_nodes_updated_at, DateTime.now) }
  after_touch -> { character.update_column(:map_nodes_updated_at, DateTime.now) }
  before_destroy -> { character.update_column(:map_nodes_updated_at, DateTime.now) }
end
