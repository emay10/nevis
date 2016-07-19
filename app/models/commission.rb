class Commission < ActiveRecord::Base
  belongs_to :client
  validates :client, presence: true

  def self.from_statement s
    user = s.user
    date = s.date
    clients = Client.where(user: user).map(&:id)
    Commission.where('client_id in (?) and statement_date >= ? and statement_date <= ?', clients, date, date.end_of_month)
  end

  def self.by_user u
    commissions = []
    clients = u.agency_data(:clients)
    if clients.length > 0
      client_ids = clients.map(&:id)
      commissions = Commission.where(client_id: client_ids)
    end
    commissions
  end
end
