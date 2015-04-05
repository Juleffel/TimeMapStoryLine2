class RpStatus < ActiveRecord::Base
    has_many :topics, inverse_of: :rp_status
    
    default_scope -> { order(:num) }
    
    validates :color, format: { with: /\A#[0-9a-fA-F]{3}[0-9a-fA-F]{3}?\z/,
        message: "Must be like #1A6F20" }
    
end
