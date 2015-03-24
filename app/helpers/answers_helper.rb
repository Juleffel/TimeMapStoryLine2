module AnswersHelper
    def answer_back_url(answer)
        if answer.topic
            topic_url(answer.topic)
        else
            categories_url
        end
    end
end
