json.extract! @statement, :id, :user_id, :date, :created_at, :updated_at
json.user @statement.user
json.total_com @statement.total_com
json.agent_com @statement.agent_com
json.carrier_com @statement.carrier_com
json.coms_by_carrier @statement.coms_by_carrier
json.carriers @carriers
json.commissions @commissions do |commission|
  json.extract! commission, :id, :statement_date, :earned_date
  json.client commission.client
  json.policy commission.client.policy
  json.user commission.client.user
  json.commission commission.commission
  json.statement_date commission.statement_date.to_time.to_i * 1000
  json.earned_date commission.earned_date.to_time.to_i * 1000
end
