load 'UIManager.rb'

class AccountOperator
  def initialize account
    @UI = UIManager.new
    @account = account
    @option = 0
  end

  def checkBalanceAvailable
    @UI.cleanScreen
    @UI.show "Saldo disponible: #{@account.balance_available}"
  end

  def checkTotalBalance
    @UI.cleanScreen
    total = @account.balance_available + @account.mattress.balance
    #Se verifica si existen bolsillos, si existen se suman al total
    pockets = Pocket.where(account_id: @account.id)
    if pockets.any?
      pockets.each do |pocket|
        total += pocket.balance
      end
    end
    #Se verifica si existen metas, si existen se suman al total
    goals = Goal.where(account_id: @account.id)
    if goals.any?
      goals.each do |goal|
        total += goal.saved_money
      end
    end
    @UI.show "Saldo total: #{total}"
  end

  def recharge
    @UI.cleanScreen
    value = @UI.getRechargeValue
    @account.balance_available += value
    if @account.save!
      createTransaction(@account, 'recarga', value)
      @UI.show "Nuevo saldo: #{@account.balance_available}"
    else
      @UI.show "Transacción anulada"
    end
  end

  def withdraw
    @UI.cleanScreen
    value = @UI.getWithdrawValue
    if @account.balance_available >= value
      @account.balance_available -= value
      if @account.save!
        createTransaction(@account, 'retiro', value)
        @UI.show "Retiró #{value}"
        @UI.show "Nuevo saldo: #{@account.balance_available}"
      else
        @UI.show "Transacción anulada"
      end
    else
      @UI.show "Saldo insuficiente"
    end
  end

  def send
    @UI.cleanScreen
    requestSendData
    if @account.balance_available >= @value
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
    @UI.cleanScreen
    numTransactions = @UI.getNumTransactions
    transactions = Transaction.select("transaction_type, amount, user_name, created_at").where(account_id: @account.id).last(numTransactions)
    @UI.show "Transacciones"
    transactions.each do |transaction|
      @UI.display transaction
    end
  end

  def sendMoney user
    user.account.balance_available += @value
    @account.balance_available -= @value
    if user.account.save! && @account.save!
      createTransaction(@account, 'envio', @value, user.name)
      createTransaction(user.account, 'recepcion', @value, @account.user.name)
      @UI.show "Le enviaste #{@value} a #{user.name}"
    else
      @UI.show "Transacción anulada"
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

  private
  def requestSendData
    @email = @UI.getEmail
    @value = @UI.getSendValue
  end

end
