class Statement < ActiveRecord::Base
  belongs_to :user

  scope :dash, -> { where('date >= ?', 2.month.ago.change(day: 1)).order(:date) }

  def coms
    Commission.from_statement(self)
  end

  def coms_by_carrier
    x = {}
    coms
      .map(&:client)
      .map(&:policy)
      .map {|p| [p.carrier, p.commission] }
      .map do |c|
        x[c[0]] = 0 unless x[c[0]]
        x[c[0]] += c[1]
        c[1]
      end
    x
  end

  def carrier_com
    coms
      .map(&:client)
      .map(&:policy)
      .map(&:commission)
      .inject(&:+) or 0
  end

  def total_com
    coms.map(&:commission).inject(&:+) or 0
  end

  def agent_com
    if user.commission
      (total_com * (user.commission / 100.0)).round(1)
    else
      0
    end
  end
end
