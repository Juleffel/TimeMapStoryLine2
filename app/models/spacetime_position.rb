class SpacetimePosition < ActiveRecord::Base
  extend HashBy
  
  has_one :topic, inverse_of: :spacetime_position
  has_many :presences, inverse_of: :spacetime_position
  has_many :characters, through: :presences, inverse_of: :spacetime_positions
  
  validate do |sp|
    sp.characters.each do |ch|
      ch.spacetime_positions.each do |ch_sp|
        if ch_sp != sp
          if (sp.begin_at >= ch_sp.begin_at and sp.begin_at <= ch_sp.end_at)
            errors.add(:base, "This spacetime position cannot begin during spacetime position #{ch_sp.id} of character #{ch.name}")
          elsif (sp.end_at >= ch_sp.begin_at and sp.end_at <= ch_sp.end_at)
            errors.add(:base, "This spacetime position cannot end during spacetime position #{ch_sp.id} of character #{ch.name}")
          end
        end
      end
    end
  end
  
  default_scope -> {order(:begin_at)}
  def end_at
    @end_at || (begin_at + 3.hours if begin_at)
  end
  
  def json_attributes
    attributes.merge({character_ids: character_ids, end_at: end_at, topic_id: (topic.id if topic)})
  end
  
  after_save -> { presences.each(&:touch) }
  after_touch -> { presences.each(&:touch) }
  before_destroy -> { presences.each(&:touch) }
end
