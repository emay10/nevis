class User < ActiveRecord::Base
  has_many :clients
  has_many :statements
  belongs_to :agency
  has_secure_password
  enum role: [:user, :manager, :admin]
end
