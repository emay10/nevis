json.array!(@commissions) do |commission|
  json.extract! commission, :id, :statement_date, :earned_date
  json.url commission_url(commission, format: :json)
  json.client commission.client
end
