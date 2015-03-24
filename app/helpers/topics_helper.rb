module TopicsHelper
    def topic_back_url(topic)
        if topic.category
          category_url(topic.category)
        elsif topic.special_category
          category_url(topic.special_category)
        elsif topic.spacetime_position
          #TODO redirect maps
          categories_url
        else
          categories_url
        end
    end
end
