json.array!(@links) do |link|
  json.extract! link, :id, :from_character_id, :to_character_id, :title, :description, :force
  json.url link_url(link, format: :json)
end
