class Goal < ActiveRecord::Base
  belongs_to :account

  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9 ]+\Z/,
    message: "Solo se permiten letras y numeros" }
  validates :state, presence: true, inclusion: { in: %w(abierta cumplida vencida),
    message: "%{value} no es un estado válido" }
  validates :saved_money, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :end_date, presence: true

  attribute :state, :string, default: "abierta"
  attribute :saved_money, :integer, default: 0
end
