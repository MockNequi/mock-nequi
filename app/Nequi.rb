load 'DBManager.rb'
load 'UIManager.rb'
load 'SessionManager.rb'

class Nequi
  def initialize
    @UI = UIManager.new
    @sessionManager = SessionManager.new
    @continue = true
    @option = 0
    dbManager = DBManager.new
    dbManager.establish_connection
  end

  def start
    # ciclo principal
    while @continue
      @option = @UI.initialMenu
      if @option == 1
        @sessionManager.signUp
      elsif @option == 2
        @sessionManager.signIn
      elsif @option == 3
        @continue = false
        puts "Saliendo"
      else
        puts "Pinchi pendejo"
      end
    end

  end

end
