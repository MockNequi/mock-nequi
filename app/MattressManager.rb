load 'UIManager.rb'
require_relative './models/mattress'

class MattressManager
  def initialize user
    @UI = UIManager.new
    @user = user
  end

  def go
    @continue = true
    while @continue
      @option = @UI.mattressMenu
      if @option == 1
        checkBalance()
      elsif @option == 2
        recharge()
      elsif @option == 3
        withdraw()
      elsif @option == 4
        @continue = false
      else
        @UI.errorMessageIncorrectInput
      end
    end
  end

  def checkBalance
    @UI.show "Dinero en colchón: #{@user.account.mattress.balance}"
  end

  def recharge
    @value = @UI.getRechargeValue
    # validaciones?
    if @user.account.balance_available >= @value
      moveMoneyTo('mattress')
    else
      @UI.show "Saldo insuficiente"
    end
  end

  def withdraw
    @value = @UI.getWithdrawValue
    # validaciones?
    if @user.account.mattress.balance >= @value
      moveMoneyTo('account')
    else
      @UI.show "Saldo en colchón insuficiente"
    end
  end

  def moveMoneyTo destination
    if destination == 'mattress'
      @user.account.balance_available -= @value
      @user.account.mattress.balance += @value
    elsif destination == 'account'
      @user.account.balance_available += @value
      @user.account.mattress.balance -= @value
    end
    if @user.account.save! && @user.account.mattress.save!
      @UI.show "Saldo disponible en cuenta: #{@user.account.balance_available}"
      @UI.show "Dinero en colchón: #{@user.account.mattress.balance}"
    else
      @UI.show "Transacción anulada"
    end
  end

end
