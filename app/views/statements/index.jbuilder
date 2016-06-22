json.array!(@statements) do |statement|
  json.extract! statement, :id, :user_id, :date, :status
  json.user_name statement.user.name
  json.month statement.date.strftime('%B')
  json.url statement_url(statement, format: :json)
end
