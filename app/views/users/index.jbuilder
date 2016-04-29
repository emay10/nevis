json.array!(@users) do |user|
  json.extract! user, :id, :email, :name, :commission
  json.url user_url(user, format: :json)
  json.agency user.agency
end
