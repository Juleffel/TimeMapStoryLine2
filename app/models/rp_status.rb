class RpStatus < ActiveRecord::Base
    has_many :topics, inverse_of: :rp_status
    
    default_scope -> { order(:num) }
    
end
