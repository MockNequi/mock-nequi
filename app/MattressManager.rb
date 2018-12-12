load 'UIManager.rb'
require_relative './models/mattress'

class MattressManager
  def initialize account
    @UI = UIManager.new
    @account = account
    @mattress = @account.mattress
  end

  def go
    @continue = true
    @UI.cleanScreen
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
        @UI.cleanScreen
      else
        @UI.errorMessageIncorrectInput
      end
    end
  end

  def checkBalance
    @UI.cleanScreen
    @UI.show "Dinero en colchón: #{@mattress.balance}"
  end

  def recharge
    @UI.cleanScreen
    @value = @UI.getRechargeValue
    # validaciones?
    if @account.balance_available >= @value
      moveMoneyTo('mattress')
    else
      @UI.show "Saldo insuficiente"
    end
  end

  def withdraw
    @UI.cleanScreen
    @value = @UI.getWithdrawValue
    if @mattress.balance >= @value
      moveMoneyTo('account')
    else
      @UI.show "Saldo en colchón insuficiente"
    end
  end

  private
  def moveMoneyTo destination
    if destination == 'mattress'
      @account.balance_available -= @value
      @mattress.balance += @value
    elsif destination == 'account'
      @account.balance_available += @value
      @mattress.balance -= @value
    end
    if @account.save! && @mattress.save!
      @UI.show "Saldo disponible en cuenta: #{@account.balance_available}"
      @UI.show "Dinero en colchón: #{@mattress.balance}"
    else
      @UI.show "Transacción anulada"
    end
  end

end
