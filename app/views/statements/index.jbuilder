json.array!(@statements) do |statement|
  json.extract! statement, :id, :user_id, :date
  json.user statement.user
  json.url statement_url(statement, format: :json)
end
