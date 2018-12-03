class CreateMattress < ActiveRecord::Migration[5.2]
  def change
    create_table :mattresses do |t|
      t.integer :balance, null: false

      t.references :account

      t.timestamps
    end
  end
end
