class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :agency, index: true, foreign_key: true
    add_column :users, :commssion_amount, :integer
  end
end
