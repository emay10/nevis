json.array!(@clients) do |client|
  json.extract! client, :id, :name, :status, :quantity, :effective_date, :notes
  json.url client_url(client, format: :json)
  json.policy client.policy
  json.user client.user
  json.created_at client.created_at.to_i*1000
end
