json.array!(@link_natures) do |link_nature|
  json.extract! link_nature, :id, :name, :description, :color
  json.url link_nature_url(link_nature, format: :json)
end
