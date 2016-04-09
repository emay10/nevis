class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.string :name
      t.string :carrier
      t.integer :kind
      t.integer :commission

      t.timestamps null: false
    end
  end
end
