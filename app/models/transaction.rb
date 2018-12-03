class Transaction < ActiveRecord::Base
  belongs_to :account

  validates :transaction_type, presence: true, inclusion: { in: %w(recarga retiro envio recepcion),
    message: "%{value} no es un tipo de transacción válido" }
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :user_name, format: { with: /\A[a-zA-Z ]*\Z/,
    message: "Solo se permiten letras" }
end
