class AddCommissionToCommissions < ActiveRecord::Migration
  def change
    add_column :commissions, :commission, :integer
  end
end
