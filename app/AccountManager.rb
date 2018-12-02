load 'UIManager.rb'

class AccountManager
  def initialize
    @UI = UIManager.new
    @continue = true
    @option = 0
  end

  def run user
    @user = user
    # Ciclo secundario
    while @continue
      @option = @UI.sessionMenu
      if @option == 1
        checkBalanceAvailable()
      elsif @option == 2
        checkTotalBalance()
      elsif @option == 3
        @continue = false
        puts "Cerrando sesión"
      else
        @UI.errorMessageIncorrectInput
      end
    end

  end

  def checkBalanceAvailable
    @UI.show "Saldo disponible: #{@user.account.balance_available}"
  end

  def checkTotalBalance
    @UI.show "Saldo total: #{@user.account.total_balance}"
  end

end
