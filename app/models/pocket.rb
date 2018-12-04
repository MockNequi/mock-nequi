class Pocket < ActiveRecord::Base
  belongs_to :account

  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9 ]+\Z/,
    message: "Solo se permiten letras y numeros" }
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0}
  attribute :balance, :integer, default: 0
end
