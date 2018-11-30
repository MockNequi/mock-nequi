load 'DBManager.rb'
require_relative './models/user'

dbManager = DBManager.new
dbManager.establish_connection

# bandera

@continue = true
@option = 0

# funciones
def number_or_nil (string)
  Integer(string || '')
rescue ArgumentError
  nil
end

def signUp
  puts "Ingrese su nombre"
  name = gets.chomp
  puts "Ingrese email"
  email = gets.chomp
  puts "Ingrese contraseña"
  password = gets.chomp
  # Validaciones donde putas?

  user = User.new(name: name, email: email, password: password)
  user.save!

  puts "Number of users: #{User.count}"
end

def signIn
  puts "email:"
  email = gets.chomp
  user = User.find_by email: email
  # Validaciones donde putas? x2
  if user
    puts "password"
    password = gets.chomp
    if user.password == password
      puts "Bienvenido #{user.name}"
      puts "Reemplazar esto por menu de logeado"
    else
      puts "contraseña incorrecta"
    end
  else
    puts "email incorrecto"
  end
end

# Menu sin sesion

def menuInitial
  puts "Digite un numero correspondiente a lo que quiere hacer"
  puts "1. Registrarse"
  puts "2. Iniciar sesion"
  puts "3. Salir"
  # option = gets.chomp.to_i
  @option = number_or_nil (gets.chomp)
end

while @continue
  menuInitial
  if @option == 1
    signUp
  elsif @option == 2
    signIn
  elsif @option == 3
    @continue = false
    puts "Saliendo"
  else
    puts "Pinchi pendejo"
  end
end

# Menu con sesion
