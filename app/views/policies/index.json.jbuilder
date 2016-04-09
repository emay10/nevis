json.array!(@policies) do |policy|
  json.extract! policy, :id, :name, :carrier, :kind, :commission
  json.url policy_url(policy, format: :json)
end
