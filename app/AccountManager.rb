load 'UIManager.rb'
load 'AccountOperator.rb'
load 'MattressManager.rb'
load 'PocketManager.rb'
load 'GoalManager.rb'
require_relative './models/transaction'

class AccountManager
  def initialize user
    @option = 0
    account = user.account
    @UI = UIManager.new
    @accountOperator = AccountOperator.new user
    @mattressManager = MattressManager.new user
    @pocketManager = PocketManager.new user
    @goalManager = GoalManager.new account
  end

  def run
    @continue = true
    # Ciclo secundario
    while @continue
      @option = @UI.sessionMenu
      if @option == 1
        @accountOperator.checkBalanceAvailable()
      elsif @option == 2
        @accountOperator.checkTotalBalance()
      elsif @option == 3
        @accountOperator.recharge()
      elsif @option == 4
        @accountOperator.withdraw()
      elsif @option == 5
        @accountOperator.send()
      elsif @option == 6
        @accountOperator.consult()
      elsif @option == 7
        @mattressManager.go()
      elsif @option == 8
        @pocketManager.go()
      elsif @option == 9
        @goalManager.go()
      elsif @option == 10
        @continue = false
        @UI.show "Cerrando sesión"
      else
        @UI.errorMessageIncorrectInput
      end
    end

  end
end
