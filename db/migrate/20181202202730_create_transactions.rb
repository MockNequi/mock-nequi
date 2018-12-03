class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :transaction_type, null: false
      t.integer :amount, null: false
      t.string :user_name

      t.references :account

      t.timestamps
    end
  end
end
