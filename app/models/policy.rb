class Policy < ActiveRecord::Base
  enum kind: [:medical, :dental, :medicare]
  has_many :clients
end
