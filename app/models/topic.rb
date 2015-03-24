class Topic < ActiveRecord::Base
    has_one :character, inverse_of: :topic
    has_one :spacetime_position, inverse_of: :topic
    has_many :answers, inverse_of: :topic, :dependent => :destroy
    belongs_to :user, inverse_of: :topics
    belongs_to :category, inverse_of: :topics
    
    validates :image_url, format: { with: /\A(https?:\/\/.*|)\z/,
        message: "Must be like 'http://...'" }
    
    after_save -> { spacetime_position.touch if spacetime_position }
    before_destroy -> { spacetime_position.touch if spacetime_position }
    
    def last_answer
        @last_answer = @last_answer || answers.last
    end
    def last_answered_at
        @last_answered_at = @last_answered_at || 
            (if last_answer then last_answer.created_at else created_at end)
    end
    def self.order(topics)
        topics = topics || []
        topics.sort { |x,y| x.last_answered_at <=> y.last_answered_at }.reverse
    end
    
    # Category extended by special categories
    # Make the link between character group and category special
    def special_category
        @special_category = @special_category || if character and character.group
            group_special = character.group.special
            if group_special.blank?
                nil
            else
                Category.specials(group_special)
            end
        end
    end
    def _category
        @_category = @_category || if category
            category
        elsif @special_category
            @special_category
        else
            nil
        end
    end
end
