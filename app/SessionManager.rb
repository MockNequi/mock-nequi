load 'UIManager.rb'
load 'AccountManager.rb'
require_relative './models/user'
require_relative './models/account'

class SessionManager
  def initialize
    @UI = UIManager.new
    @accoutManager = AccountManager.new
  end

  def signUp
    requestRegistrationData
    # Validaciones donde putas?
    createUser
  end

  def signIn
    requestLoginData
    user = User.find_by email: @email
    # Validaciones donde putas? x2
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
    @user = User.new(name: @name, email: @email, password: @password)
    if @user.save!
      @UI.show "Usuario creado"
      createAccount()
    else
      @UI.show "Error al crear usuario" #Mensaje especifico?
    end
  end

  def createAccount
    account = Account.new user: @user
    if account.save!
      createMattress()
    else
      @UI.show "Error al crear cuenta" #Mensaje especifico?
    end
  end

  def createMattress
    mattress = Mattress.new account: @user.account
    unless mattress.save!
      @UI.show "Error al crear colchón" #Mensaje especifico?
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
    @accoutManager.run user
  end

end
