class User < ActiveRecord::Base
  has_one :account

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  # Modificar para validar email, guardar en minuscula con un callback
end
