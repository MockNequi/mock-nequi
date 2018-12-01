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
    name = @UI.getName
    email = @UI.getEmail
    password = @UI.getPassword
    # Validaciones donde putas?
    createUser(name, email, password)
  end

  def signIn
    email = @UI.getEmail
    user = User.find_by email: email
    # Validaciones donde putas? x2
    if user
      password = @UI.getPassword
      if user.password == password
        @UI.show "Bienvenido #{user.name}"
        logIn user
      else
        @UI.show "contraseña incorrecta"
      end
    else
      @UI.show "email incorrecto"
    end
  end

  def createUser (name, email, password)
    user = User.new(name: name, email: email, password: password)
    if user.save!
      @UI.show "Usuario creado"
      account = Account.new user: user
      if account.save!
        puts "cuenta creada"
      else
        puts "puta"
      end
    else
      puts "Error al crear usuario"
    end
  end

  def logIn user
    @accoutManager.run user
  end

end
