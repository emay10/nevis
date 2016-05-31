class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.references :user, index: true, foreign_key: true
      t.date :date

      t.timestamps null: false
    end
  end
end
