class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :agency, index: true, foreign_key: true
    add_column :users, :commission, :integer
    add_column :users, :role, :integer, default: 0, null: false
    add_column :users, :name, :string
  end
end
