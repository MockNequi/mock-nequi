class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|
      t.string :name, null: false
      t.string :state, null: false
      t.integer :saved_money, null: false
      t.integer :total_amount, null: false
      t.date :end_date, null: false

      t.references :account

      t.timestamps
    end
  end
end
