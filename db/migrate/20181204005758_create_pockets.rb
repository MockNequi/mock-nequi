class CreatePockets < ActiveRecord::Migration[5.2]
  def change
    create_table :pockets do |t|
      t.string :name, null: false
      t.integer :balance, null: false

      t.references :account

      t.timestamps
    end
  end
end
