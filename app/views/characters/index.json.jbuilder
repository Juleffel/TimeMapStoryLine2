json.array!(@characters) do |character|
  json.extract! character, :id, :user_id, :first_name, :last_name, :birth_date, :birth_place, :sex, :avatar_url, :avatar_name, :copyright, :topic_id, :story, :resume, :anecdote, :test_rp, :psychology, :appearance, :faction_id, :group_id
  json.url character_url(character, format: :json)
end
