class AddFieldsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :status, :integer
    add_reference :clients, :user, index: true, foreign_key: true
    add_reference :clients, :policy, index: true, foreign_key: true
    add_column :clients, :quantity, :integer
  end
end
