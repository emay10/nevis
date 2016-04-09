class User < ActiveRecord::Base
  has_many :clients
  belongs_to :agency
  has_secure_password
end
