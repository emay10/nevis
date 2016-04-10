class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|
      t.references :client, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :policy, index: true, foreign_key: true
      t.integer :amount, null: false, default: 0

      t.timestamps null: false
    end
  end
end
