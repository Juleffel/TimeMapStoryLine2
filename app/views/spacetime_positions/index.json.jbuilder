json.array!(@spacetime_positions) do |spacetime_position|
  json.extract! spacetime_position, :id, :longitude, :latitude, :title, :subtitle, :resume, :weather, :begin_at, :end_at, :topic_id
  json.url spacetime_position_url(spacetime_position, format: :json)
end
