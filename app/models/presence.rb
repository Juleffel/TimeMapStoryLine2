class Presence < ActiveRecord::Base
  belongs_to :spacetime_position, inverse_of: :presences, touch: true
  belongs_to :character, inverse_of: :presences, touch: true
end
