class UpdatePortfolio < TransactionScript
  def run(params)
    user = params[:user]
    portfolio_info = params[:portfolio]

    if user.nil? || user.guest
      return failure("User needs to be logged in")
    end

    if portfolio_info.nil? || portfolio_info[:id].nil?
      return failure("Need a portfolio id to run")
    end

    portfolio = Portfolio.find_by id: portfolio_info[:id]

    if portfolio.nil?
      return failure("Portfolio with the given id was not found")
    elsif portfolio.user.id != user.id
      return failure("Portfolio with the given id does not belong to you")
    end

    portfolio_info.delete :id

    if portfolio_info.include?(:cash_balance) && portfolio_info[:cash_balance] != portfolio.cash_balance
      return failure("Cannot directly change cash balance")
    end

    portfolio.update(portfolio_info)
    return success(portfolio: portfolio)
  end
end