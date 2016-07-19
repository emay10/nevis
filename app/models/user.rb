class User < ActiveRecord::Base
  has_many :clients
  has_many :statements
  belongs_to :agency
  has_secure_password
  enum role: [:user, :manager, :admin]

  def coworkers
    agency.users
  end

  def co_ids
    coworkers.map(&:id)
  end

  def agency_data rel
    coworkers.map(&rel).flatten
  end
end
