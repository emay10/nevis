json.array!(@commissions) do |commission|
  json.extract! commission, :id, :statement_date, :earned_date
  json.url commission_url(commission, format: :json)
  json.client commission.client
  json.policy commission.client.policy
  json.user commission.client.user
end
