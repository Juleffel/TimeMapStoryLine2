module TopicsHelper
    def topic_back_url(topic)
        if topic.category
          category_url(topic.category)
        elsif topic.spacetime_position
          #TODO redirect maps
          topics_url
        else
          topics_url
        end
    end
end
