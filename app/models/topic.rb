class Topic < ActiveRecord::Base
    has_one :character, inverse_of: :topic
    has_one :spacetime_position, inverse_of: :topic
    has_many :answers, inverse_of: :topic, :dependent => :destroy
    belongs_to :user, inverse_of: :topics
    belongs_to :category, inverse_of: :topics
    
    validates :image_url, format: { with: /\Ahttps?:\/\//,
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
    
    def _category
        @_category = @_category || if category
            category
        elsif character and character.group
            group_name = character.group.name
            if group_name == "Non-validé"
                Category.special_non_valid
            elsif group_name == "Abandonné" or group_name == "Décédé"
                Category.special_dead
            elsif character.pv
                Category.special_pv
            else
                Category.special_valid
            end
        else
            nil
        end
    end
end
