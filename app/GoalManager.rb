load 'UIManager.rb'
require_relative './models/goal'

class GoalManager
  def initialize account
    @UI = UIManager.new
    @account = account
  end

  def go
    @continue = true
    while @continue
      @option = @UI.accountMenu
      if @option == 1
        checkGoals()
      elsif @option == 2
        createGoal()
      elsif @option == 3
        closeGoal()
      elsif @option == 4
        addMoney()
      elsif @option == 5
        @continue = false
      else
        @UI.errorMessageIncorrectInput
      end
    end
  end

  def checkGoals
    goals = Goal.where(account_id: @account.id)
    @UI.showGoals goals
  end

  def createGoal
    requestGoalData
    goal = Goal.new(name: @name, total_amount: @totalAmount, end_date: @endDate, account_id: @account.id)
    goal.save!
  end

  def closeGoal
    goals = Goal.where(account_id: @account.id)
    @UI.show "Digite el número correspondiente a la meta que desea cerrar"
    number = @UI.getGoal goals
    goal = goals[number-1]
    @account.balance_available += goal.saved_money
    goal.destroy
    @account.save!
    @UI.show "#{goal.name} eliminada"
    @UI.show "Saldo disponible en cuenta: #{@account.balance_available}"
  end

  def addMoney
    goals = Goal.where(account_id: @account.id, state: "abierta")
    @UI.show "Digite el número correspondiente a la meta a la que desea agregar dinero"
    number = @UI.getGoal goals
    goal = goals[number-1]
    @value = @UI.getRechargeValue
    # validaciones?
    if @account.balance_available >= @value
      @account.balance_available -= @value
      goal.saved_money += @value
      if @account.save! && goal.save!
        @UI.show "Saldo disponible en cuenta: #{@account.balance_available}"
        @UI.show "Dinero ahorrado en meta: #{goal.saved_money}"
      else
        @UI.show "Transacción anulada"
      end
    else
      @UI.show "Saldo insuficiente"
    end
  end

  def requestGoalData
    @name = @UI.getName
    @totalAmount = @UI.getTotalAmount
    @endDate = @UI.getEndDate
  end

end
