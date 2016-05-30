json.array!(@commissions) do |commission|
  json.extract! commission, :id
  json.url commission_url(commission, format: :json)
  json.client commission.client
  json.policy commission.client.policy
  json.user commission.client.user
  json.commission commission.commission
  json.statement_date commission.statement_date.to_time.to_i * 1000
  json.earned_date commission.earned_date.to_time.to_i * 1000
end
