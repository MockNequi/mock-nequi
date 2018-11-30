class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.integer :total_balance, null: false
      t.integer :balance_available, null: false

      t.references :user

      t.timestamps
    end
  end
end
