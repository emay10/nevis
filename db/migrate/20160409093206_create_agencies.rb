class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :name
      t.text :notes

      t.timestamps null: false
    end
  end
end
