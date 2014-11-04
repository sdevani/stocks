class AddRemoveMoneyFromPortfolio < TransactionScript
  def run(params)
    if params[:user_id].nil? || params[:portfolio_id].nil?
      return failure("Need user and portfolio id to make transaction")
    end

    portfolio = Portfolio.find_by(user_id: params[:user_id],
      id: params[:portfolio_id])

    if portfolio.nil?
      return failure("Given user does not own the portfolio")
    end

    change_in_balance = params[:change_in_balance]

    if change_in_balance.nil?
      return failure("Need monetary amount to withdraw or deposit")
    end

    new_cash_balance = portfolio.cash_balance + change_in_balance.to_d

    if new_cash_balance < 0
      return failure("Can't withdraw more money than you have")
    end

    portfolio.cash_balance = new_cash_balance
    portfolio.save
    return success(portfolio: portfolio)
  end
end