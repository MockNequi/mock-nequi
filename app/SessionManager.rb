load 'UIManager.rb'

class SessionManager
  def initialize
    @UI = UIManager.new()
  end

  def signUp
    name = @UI.getName
    email = @UI.getEmail
    password = @UI.getPassword
    # Validaciones donde putas?

    user = User.new(name: name, email: email, password: password)
    if user.save!
      @UI.show "Usuario creado"
    else
      @UI.show "Error al crear usuario"
    end
  end

  def signIn
    email = @UI.getEmail
    user = User.find_by email: email
    # Validaciones donde putas? x2
    if user
      password = @UI.getPassword
      if user.password == password
        @UI.show "Bienvenido #{user.name}"
        logIn
      else
        @UI.show "contraseña incorrecta"
      end
    else
      @UI.show "email incorrecto"
    end
  end

  def logIn
    puts "Reemplazar esto por menu de logeado"
  end

end
