load 'UIManager.rb'
require_relative './models/pocket'

class PocketManager
  def initialize user
    @UI = UIManager.new
    @user = user
  end

  def go
    @continue = true
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
      else
        @UI.errorMessageIncorrectInput
      end
    end
  end

  def checkPockets
    pockets = Pocket.where(account_id: @user.account.id)
    @UI.show "Bolsillos"
    pockets.each do |pocket|
      @UI.show "Nombre: #{pocket.name}"
      @UI.show "Saldo: #{pocket.balance}"
    end
  end

  def createPocket
    name = @UI.getName
    pocket = Pocket.new(account: @user.account, name: name)
    if pocket.save!
      @UI.show "Bolsillo creado"
    else
      @UI.show "Error al crear bolsillo"
    end
  end

  def deletePocket
    pockets = Pocket.where(account_id: @user.account.id)
    @UI.show "Digite el número correspondiente al bolsillo que desea eliminar"
    for i in 1..pockets.length
      @UI.show "#{i}. #{pockets[i-1].name}: #{pockets[i-1].balance}"
    end
    input = gets.chomp.to_i
    pocket = pockets[input-1]
    @user.account.balance_available += pocket.balance
    pocket.destroy
    @user.account.save!
    @UI.show "#{pocket.name} eliminado"
    @UI.show "Saldo disponible en cuenta: #{@user.account.balance_available}"
  end

  def recharge
    pockets = Pocket.where(account_id: @user.account.id)
    @UI.show "Digite el número correspondiente al bolsillo que desea recargar"
    number = @UI.getPocket pockets
    @pocket = pockets[number-1]
    @value = @UI.getRechargeValue
    # validaciones?
    if @user.account.balance_available >= @value
      moveMoneyTo('pocket')
    else
      @UI.show "Saldo insuficiente"
    end
  end

  def withdraw
    pockets = Pocket.where(account_id: @user.account.id)
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

  def moveMoneyTo destination
    if destination == 'pocket'
      @user.account.balance_available -= @value
      @pocket.balance += @value
    elsif destination == 'account'
      @user.account.balance_available += @value
      @pocket.balance -= @value
    end
    if @user.account.save! && @pocket.save!
      @UI.show "Saldo disponible en cuenta: #{@user.account.balance_available}"
      @UI.show "Dinero en bolsillo: #{@pocket.balance}"
    else
      @UI.show "Transacción anulada"
    end
  end

  def sendMoney
    pockets = Pocket.where(account_id: @user.account.id)
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

  def requestSendData
    @email = @UI.getEmail
    @value = @UI.getSendValue
  end

  def sendTo user
    user.account.balance_available += @value
    @pocket.balance -= @value
    if user.account.save! && @pocket.save!
      accountOperator = AccountOperator.new @user
      accountOperator.createTransaction(@user.account, 'envio', @value, user.name)
      accountOperator.createTransaction(user.account, 'recepcion', @value, @user.name)
      @UI.show "Le enviaste #{@value} a #{user.name}"
    else
      @UI.show "Transacción anulada"
    end
  end

end
