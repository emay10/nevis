class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|
      t.references :client, index: true, foreign_key: true
      t.date :statement_date
      t.date :earned_date
    end
  end
end
