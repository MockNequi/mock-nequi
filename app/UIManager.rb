require 'digest'

class UIManager

  def show message
    puts message
  end

  # Menu sin sesion
  def initialMenu
    puts "Digite un numero correspondiente a lo que quiere hacer"
    puts "1. Registrarse"
    puts "2. Iniciar sesion"
    puts "3. Salir"

    number_or_nil (gets.chomp)
  end

  # Menu de sesion
  def sessionMenu
    puts "Digite un numero correspondiente a lo que quiere hacer"
    puts "1. Consultar saldo disponible"
    puts "2. Consultar saldo total"
    puts "3. Recargar"
    puts "4. Retirar"
    puts "5. Enviar"
    puts "6. Consultar transacciones"
    puts "7. Cerrar sesión"

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
    # El metodo de encriptacion no debe ir aca
    Digest::SHA2.hexdigest  password
  end

  def getRechargeValue
    puts "Cuánto desea recargar?"
    number_or_nil (gets.chomp)
  end

  def getWithdrawValue
    puts "Cuánto desea retirar?"
    number_or_nil (gets.chomp)
  end

  def getSendValue
    puts "Cuánto desea enviar?"
    number_or_nil (gets.chomp)
  end

  # Mensajes de error
  def errorMessageIncorrectInput
    puts "Entrada incorrecta"
  end

  # Validaciones
  def number_or_nil (string)
    Integer(string || '')
  rescue ArgumentError
    nil
  end

end
