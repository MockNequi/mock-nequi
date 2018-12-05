class Account < ActiveRecord::Base
  belongs_to :user
  has_one :mattress
  has_many :pockets
  has_many :goals

  validates :total_balance, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :balance_available, presence: true, numericality: { greater_than_or_equal_to: 0}
  attribute :total_balance, :integer, default: 0
  attribute :balance_available, :integer, default: 0
end
