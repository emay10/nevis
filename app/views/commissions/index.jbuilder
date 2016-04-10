json.array!(@commissions) do |commission|
  json.extract! commission, :id, :amount
  json.url commission_url(commission, format: :json)
  json.policy commission.policy
  json.user do
    json.extract! commission.user, :email, :name
  end
  json.client commission.client
end
