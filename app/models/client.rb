class Client < ActiveRecord::Base
  belongs_to :user
  belongs_to :policy
  enum status: [:active, :inactive, :pending]
  validates :name, presence: true

  scope :search, -> (q) {
    includes(:user, :policy)
      .where(
        'users.name like ? or policies.carrier like ? or policies.name like ?',
        "%#{q}%", "%#{q}%", "%#{q}%"
      )
      .references(:user, :policy)
  }
end
