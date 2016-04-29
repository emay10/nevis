json.array!(@clients) do |client|
  json.extract! client, :id, :name, :email, :status, :quantity
  json.url client_url(client, format: :json)
  json.policy client.policy
end
