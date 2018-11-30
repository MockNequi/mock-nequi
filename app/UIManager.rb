class UIManager

  def show message
    puts message
  end

  # Menu sin sesion
  def menuInitial
    puts "Digite un numero correspondiente a lo que quiere hacer"
    puts "1. Registrarse"
    puts "2. Iniciar sesion"
    puts "3. Salir"

    number_or_nil (gets.chomp)
  end

  def getName
    puts "Ingrese su nombre"
    name = gets.chomp
  end

  def getEmail
    puts "Ingrese email"
    email = gets.chomp
  end

  def getPassword
    puts "Ingrese contraseña"
    password = gets.chomp
  end

  def number_or_nil (string)
    Integer(string || '')
  rescue ArgumentError
    nil
  end

end
