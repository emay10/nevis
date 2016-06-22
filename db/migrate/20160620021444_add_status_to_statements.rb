class AddStatusToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :status, :boolean, null: false, default: false
  end
end
