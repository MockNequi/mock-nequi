class Account < ActiveRecord::Base
  belongs_to :user

  validates :total_balance, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :balance_available, presence: true, numericality: { greater_than_or_equal_to: 0}
  attribute :total_balance, :integer, default: 0
  attribute :balance_available, :integer, default: 0
end
