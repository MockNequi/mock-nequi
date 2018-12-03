load 'UIManager.rb'
require_relative './models/transaction'

class AccountManager
  def initialize
    @UI = UIManager.new
    @option = 0
  end

  def run user
    @user = user
    @continue = true
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
        send()
      elsif @option == 6
        consult()
      elsif @option == 7
        @continue = false
        @UI.show "Cerrando sesión"
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
      transaction = Transaction.new(account: @user.account, transaction_type: 'recarga', amount: value)
      unless transaction.save!
        @UI.show "Error al crear transacción"
      end
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
        transaction = Transaction.new(account: @user.account, transaction_type: 'retiro', amount: value)
        unless transaction.save!
          @UI.show "Error al crear transacción"
        end
        @UI.show "Retiró #{value}"
        @UI.show "Nuevo saldo: #{@user.account.balance_available}"
      else
        @UI.show "Transacción anulada"
      end
    else
      @UI.show "Saldo insuficiente"
    end
  end

  def send
    requestSendData
    if @user.account.balance_available >= @value
      receivingUser = User.find_by email: @email
      if receivingUser
        receivingUser.account.balance_available += @value
        @user.account.balance_available -= @value
        if receivingUser.account.save! && @user.account.save!
          transaction = Transaction.new(account: @user.account, user_name: receivingUser.name, transaction_type: 'envio', amount: @value)
          transaction2 = Transaction.new(account: receivingUser.account, user_name: @user.name, transaction_type: 'recepcion', amount: @value)
          unless transaction.save! && transaction2.save!
            @UI.show "Error al crear transacción"
          end
          @UI.show "Le enviaste #{@value} a #{receivingUser.name}"
        else
          @UI.show "Transacción anulada"
        end
      else
        @UI.show "No existe el usuario #{@email}"
      end
    else
      @UI.show "Saldo insuficiente"
    end
  end

  def consult
    numTransactions = @UI.getNumTransactions
    transactions = Transaction.select("transaction_type, amount, user_name, created_at").where(account_id: @user.account.id).last(numTransactions)
    @UI.show "Transacciones"
    transactions.each do |transaction|
      @UI.display transaction
    end
  end

  def requestSendData
    @email = @UI.getEmail
    @value = @UI.getSendValue
  end

end
