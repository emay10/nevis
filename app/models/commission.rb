class Commission < ActiveRecord::Base
  belongs_to :client
  validates :client, presence: true

  def self.from_statement s
    user = s.user
    date = s.date
    clients = Client.where(user: user).map(&:id)
    Commission.where('client_id in (?) and statement_date >= ? and statement_date <= ?', clients, date, date.end_of_month)
  end
end
