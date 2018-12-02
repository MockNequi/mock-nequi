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
        recharge()
      elsif @option == 4
        withdraw()
      elsif @option == 5
        puts "Envio"
      elsif @option == 6
        puts "Consulta"
      elsif @option == 7
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
    # Si debe existir este campo? o mejor que consulte los otros campos y los sume?
    @UI.show "Saldo total: #{@user.account.total_balance}"
  end

  def recharge
    value = @UI.getRechargeValue
    # validaciones?
    @user.account.balance_available += value
    if @user.account.save!
      @UI.show "Nuevo saldo: #{@user.account.balance_available}"
    else
      @UI.show "Transacción anulada"
    end
  end

  def withdraw
    value = @UI.getWithdrawValue
    if @user.account.balance_available >= value
      @user.account.balance_available -= value
      if @user.account.save!
        @UI.show "Retiró #{value}"
        @UI.show "Nuevo saldo: #{@user.account.balance_available}"
      else
        @UI.show "Transacción anulada"
      end
    else
      @UI.show "Saldo insuficiente"
    end
  end

end
