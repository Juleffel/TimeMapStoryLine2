module TopicsHelper
    FORMAT = "%Y-%m-%dT%H:%M:%S+00:00"
    def topic_back_url(topic)
        if topic.category
          category_url(topic.category)
        elsif topic.special_category
          category_url(topic.special_category)
        elsif topic.spacetime_position
          map_characters_url(date: topic.spacetime_position.begin_at.strftime(FORMAT))
        else
          categories_url
        end
    end
    def topic_back_categories_url(topic)
        if topic.category
          category_url(topic.category)
        elsif topic.special_category
          category_url(topic.special_category)
        else
          categories_url
        end
    end
    def topic_back_map_url(topic)
        map_characters_url(date: topic.spacetime_position.begin_at.strftime(FORMAT))
    end
end
