class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :quantity, null: false, default: 1
      t.references :policy, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :status, null: false, default: 1
      t.text :notes
      t.date :effective_date

      t.timestamps null: false
    end
  end
end
