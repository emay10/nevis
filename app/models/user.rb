class User < ActiveRecord::Base
  has_many :clients
  has_many :statements
  belongs_to :agency
  has_secure_password
  enum role: [:user, :manager, :admin]

  def coworkers
    agency.users if agency
  end

  def co_ids
    coworkers.map(&:id) if coworkers and coworkers.length > 0
  end

  def agency_data rel
    coworkers.map(&rel).flatten if coworkers and coworkers.length > 0
  end
end
