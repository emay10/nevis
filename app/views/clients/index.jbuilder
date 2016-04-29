json.array!(@clients) do |client|
  json.extract! client, :id, :name, :email, :status
  json.url client_url(client, format: :json)
end
