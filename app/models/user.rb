class User < ActiveRecord::Base
  has_one :account

  validates :name, presence: true, format: { with: /\A[a-zA-Z ]+\Z/,
    message: "Solo se permiten letras" }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  # Modificar para validar email, guardar en minuscula con un callback
end
