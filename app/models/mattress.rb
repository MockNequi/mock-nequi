class Mattress < ActiveRecord::Base
  belongs_to :account

  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0}
  attribute :balance, :integer, default: 0
end
