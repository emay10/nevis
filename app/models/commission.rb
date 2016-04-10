class Commission < ActiveRecord::Base
  belongs_to :client
  belongs_to :user
  belongs_to :policy
  validates :client, presence: true
  validates :user, presence: true
  validates :policy, presence: true
end
