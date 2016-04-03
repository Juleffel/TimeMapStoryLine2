class Topic < ActiveRecord::Base
    extend HashBy

    belongs_to :spacetime_position, inverse_of: :topic
    has_many :answers, inverse_of: :topic, :dependent => :destroy
    belongs_to :user, inverse_of: :topics
    belongs_to :category, inverse_of: :topics
    belongs_to :rp_status, inverse_of: :topics
    # If it's a topic for a character sheet
    has_one :character, inverse_of: :topic 
    # If it's a topic for character links
    has_one :links_character, inverse_of: :links_topic, foreign_key: :links_topic_id, class_name: "Character"
    # If it's a topic for character rps
    has_one :rps_character, inverse_of: :rps_topic, foreign_key: :rps_topic_id, class_name: "Character"
    
    validates :image_url, format: { with: /\A(https?:\/\/.*|)\z/,
        message: "Must be like 'http://...'" }
    
    after_save -> { spacetime_position.touch if spacetime_position }
    after_touch -> { spacetime_position.touch if spacetime_position }
    before_destroy -> { spacetime_position.touch if spacetime_position }
    
    def last_answer
        @last_answer = @last_answer || answers.last
    end
    def last_answered_at
        @last_answered_at = @last_answered_at || 
            (if last_answer then last_answer.created_at else created_at end)
    end
    def last_answered_by
        if last_answer and last_answer.character
            last_answer.character.name
        elsif last_answer and last_answer.user
            last_answer.user.pseudo
        elsif user
            user.pseudo
        end
    end
    def self.order_topics(topics)
        topics = topics || []
        topics.sort { |x,y| x.last_answered_at <=> y.last_answered_at }.reverse
    end
    def self.filter_recent(topics, nb_days)
        topics.keep_if {|t| t.last_answered_at >= DateTime.now - nb_days.days}
    end
    def participants
        @participants = @participants || answers.map(&:character).uniq.compact
    end
    def self.filter_status(topics, rp_status)
        p topics
        p rp_status
        topics.to_a.select {|t| t.rp_status_id == rp_status.id}
    end
    
    # Make the link between character group and category special
    def special_category
        @special_category = @special_category || if character and character.group
            group_special = character.group.special
            if group_special.blank?
                nil
            else
                Category.specials(group_special)
            end
        elsif links_character
            Category.special_role(:links)
        elsif rps_character
            Category.special_role(:rps)
        end
    end
    # Category extended by special categories
    def _category
        @_category = @_category || if category
            category
        elsif special_category
            special_category
        else
            nil
        end
    end
    # Special character
    def special_character
        character || links_character || rps_character
    end
    
    def self.rpg_topics
        Topic.all.includes(:category).where('categories.is_rpg' => true)
    end
    def self.flood_topics
        Topic.all.includes(:category).where('categories.is_flood' => true)
    end
    def self.other_topics
        Topic.all.includes(:category).where('categories.is_rpg' => false, 'categories.is_flood' => false)
    end
    def self.auto_topics(topic_includes)
        characters = Character.all.includes(topic: topic_includes, links_topic: topic_includes, rps_topic: topic_includes)
        topics = []
        characters.each do |character|
            topics << character.topic
            if not character.npc
                topics << character.links_topic
                topics << character.rps_topic
            end
        end
        topics
    end
    
    def json_attributes
        attributes.merge(last_answered_at: last_answered_at, last_answered_by: last_answered_by, nb_answers: answers.length)
    end
end
