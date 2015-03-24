json.array!(@presences) do |presence|
  json.extract! presence, :id, :node_id, :character_id
  json.url presence_url(presence, format: :json)
end
