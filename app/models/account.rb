class Account < ActiveRecord::Base
  belongs_to :user

  validates :total_balance, presence: true
  validates :balance_available, presence: true
  attribute :total_balance, :integer, default: 0
  attribute :balance_available, :integer, default: 0
end
