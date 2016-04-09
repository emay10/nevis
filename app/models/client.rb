class Client < ActiveRecord::Base
  belongs_to :user
  belongs_to :policy
  enum status: [:active, :inactive, :pending]
  validates :name, presence: true
end
