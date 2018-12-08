class User < ActiveRecord::Base
  has_one :account

  validates :name, presence: true, format: { with: /\A[a-zA-Z ]+\Z/,
    message: "Solo se permiten letras" }
  validates :email, presence: true, uniqueness: true, format: { with: /([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i,
    message: "invalido" }
  validates :password, presence: true

  before_validation :downcase_email

  private
  def downcase_email
    self.email = email.downcase if email.present?
  end
end
