load 'UIManager.rb'
require_relative './models/pocket'

class PocketManager
  def initialize account
    @UI = UIManager.new
    @account = account
  end

  def go
    @continue = true
    @UI.cleanScreen
    while @continue
      @option = @UI.pocketMenu
      if @option == 1
        checkPockets()
      elsif @option == 2
        createPocket()
      elsif @option == 3
        deletePocket()
      elsif @option == 4
        recharge()
      elsif @option == 5
        withdraw()
      elsif @option == 6
        sendMoney()
      elsif @option == 7
        @continue = false
        @UI.cleanScreen
      else
        @UI.errorMessageIncorrectInput
      end
    end
  end

  def checkPockets
    @UI.cleanScreen
    pockets = Pocket.where(account_id: @account.id)
    @UI.showPockets pockets
  end

  def createPocket
    @UI.cleanScreen
    name = @UI.getName
    pocket = Pocket.new(account: @account, name: name)
    if pocket.save!
      @UI.show "Bolsillo creado"
    else
      @UI.show "Error al crear bolsillo"
    end
  end

  def deletePocket
    @UI.cleanScreen
    pockets = Pocket.where(account_id: @account.id)
    @UI.show "Digite el número correspondiente al bolsillo que desea eliminar"
    for i in 1..pockets.length
      @UI.show "#{i}. #{pockets[i-1].name}: #{pockets[i-1].balance}"
    end
    input = gets.chomp.to_i
    pocket = pockets[input-1]
    @account.balance_available += pocket.balance
    pocket.destroy
    @account.save!
    @UI.show "#{pocket.name} eliminado"
    @UI.show "Saldo disponible en cuenta: #{@account.balance_available}"
  end

  def recharge
    @UI.cleanScreen
    pockets = Pocket.where(account_id: @account.id)
    @UI.show "Digite el número correspondiente al bolsillo que desea recargar"
    number = @UI.getPocket pockets
    @pocket = pockets[number-1]
    @value = @UI.getRechargeValue
    # validaciones?
    if @account.balance_available >= @value
      moveMoneyTo('pocket')
    else
      @UI.show "Saldo insuficiente"
    end
  end

  def withdraw
    @UI.cleanScreen
    pockets = Pocket.where(account_id: @account.id)
    @UI.show "Digite el número correspondiente al bolsillo del que desea retirar"
    number = @UI.getPocket pockets
    @pocket = pockets[number-1]
    @value = @UI.getWithdrawValue
    # validaciones?
    if @pocket.balance >= @value
      moveMoneyTo('account')
    else
      @UI.show "Saldo en bolsillo insuficiente"
    end
  end

  def sendMoney
    @UI.cleanScreen
    pockets = Pocket.where(account_id: @account.id)
    @UI.show "Digite el número correspondiente al bolsillo del que desea enviar dinero"
    number = @UI.getPocket pockets
    @pocket = pockets[number-1]
    requestSendData
    if @pocket.balance >= @value
      receivingUser = User.find_by_email @email
      if receivingUser
        sendTo(receivingUser)
      else
        @UI.show "No existe el usuario #{@email}"
      end
    else
      @UI.show "Saldo insuficiente en bolsillo"
    end
  end

  private
  def moveMoneyTo destination
    if destination == 'pocket'
      @account.balance_available -= @value
      @pocket.balance += @value
    elsif destination == 'account'
      @account.balance_available += @value
      @pocket.balance -= @value
    end
    if @account.save! && @pocket.save!
      @UI.show "Saldo disponible en cuenta: #{@account.balance_available}"
      @UI.show "Dinero en bolsillo: #{@pocket.balance}"
    else
      @UI.show "Transacción anulada"
    end
  end

  def requestSendData
    @email = @UI.getEmail
    @value = @UI.getSendValue
  end

  def sendTo user
    user.account.balance_available += @value
    @pocket.balance -= @value
    if user.account.save! && @pocket.save!
      accountOperator = AccountOperator.new @user
      accountOperator.createTransaction(@account, 'envio', @value, user.name)
      accountOperator.createTransaction(user.account, 'recepcion', @value, @account.user.name)
      @UI.show "Le enviaste #{@value} a #{user.name}"
    else
      @UI.show "Transacción anulada"
    end
  end

end
