load 'UIManager.rb'

class AccountOperator
  def initialize user
    @UI = UIManager.new
    @user = user
    @option = 0
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
      createTransaction(@user.account, 'recarga', value)
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
        createTransaction(@user.account, 'retiro', value)
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
        sendMoney(receivingUser)
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

  def createTransaction(account, transaction_type, amount, *user_name)
    if user_name.empty?
      transaction = Transaction.new(account: account, transaction_type: transaction_type, amount: amount)
    else
      transaction = Transaction.new(account: account, transaction_type: transaction_type, amount: amount, user_name: user_name[0])
    end
    unless transaction.save!
      @UI.show "Error al crear transacción"
    end
  end

  def sendMoney user
    user.account.balance_available += @value
    @user.account.balance_available -= @value
    if user.account.save! && @user.account.save!
      createTransaction(@user.account, 'envio', @value, user.name)
      createTransaction(user.account, 'recepcion', @value, @user.name)
      @UI.show "Le enviaste #{@value} a #{user.name}"
    else
      @UI.show "Transacción anulada"
    end
  end

  def requestSendData
    @email = @UI.getEmail
    @value = @UI.getSendValue
  end

end
