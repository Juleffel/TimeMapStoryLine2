json.array!(@rp_statuses) do |rp_status|
  json.extract! rp_status, :id, :name, :description, :color
  json.url rp_status_url(rp_status, format: :json)
end
