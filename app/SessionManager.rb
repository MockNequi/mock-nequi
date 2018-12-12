require 'digest'
load 'UIManager.rb'
load 'AccountManager.rb'
require_relative './models/user'
require_relative './models/account'

class SessionManager
  def initialize
    @UI = UIManager.new
  end

  def signUp
    requestRegistrationData
    createUser
  end

  def signIn
    requestLoginData
    convertPassword
    user = User.find_by_email @email
    @UI.cleanScreen
    if user
      if user.password == @password
        @UI.show "Bienvenido #{user.name}"
        logIn user
      else
        @UI.show "contraseña incorrecta"
      end
    else
      @UI.show "email incorrecto"
    end
  end

  def createUser
    @UI.cleanScreen
    begin
      validatePassword()
      convertPassword()
      @user = User.new(name: @name, email: @email, password: @password)
      @user.save!
      createAccount()
      @UI.show "Usuario creado"
    rescue StandardError => e
      @UI.show "Error al crear usuario: #{e.message}"
    end
  end

  private
  def createAccount
    account = Account.new user: @user
    if account.save!
      createMattress()
    else
      @UI.show "Error al crear cuenta"
    end
  end

  def createMattress
    mattress = Mattress.new account: @user.account
    unless mattress.save!
      @UI.show "Error al crear colchón"
    end
  end

  def requestRegistrationData
    @name = @UI.getName
    @email = @UI.getEmail
    @password = @UI.getPassword
  end

  def requestLoginData
    @email = @UI.getEmail
    @password = @UI.getPassword
  end

  def logIn user
    @accoutManager = AccountManager.new user
    @accoutManager.run
  end

  def validatePassword
    if @password.length < 4
      raise "La longitud mínima de la contraseña es de 4 caracteres"
    end
  end

  def convertPassword
    @password = Digest::SHA2.hexdigest @password
  end

end
