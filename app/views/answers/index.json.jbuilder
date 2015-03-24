json.array!(@answers) do |answer|
  json.extract! answer, :id, :title, :content, :topic_id
  json.url answer_url(answer, format: :json)
end
