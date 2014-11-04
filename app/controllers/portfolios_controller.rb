class PortfoliosController < ApplicationController

  # POST /api/portfolios
  # payload: {portfolio: {nickname: "abc", cash_balance: 100}}
  def create
    result = Portfolio.create_for_user(portfolio_params.merge({user: current_user}))
    if result.success?
      render json: result.portfolio
    else
      render json: {error: result.error}, status: :unprocessable_entity
    end
  end

  # GET /api/portfolios
  def index
    if current_user.guest
      render json: {error: "User needs to be logged in"}, status: :unprocessable_entity
    else
      render json: current_user.portfolios
    end
  end

  # POST /api/portfolios/1
  # payload: {portfolio: {nickname: "abc"}}
  def update
    result = UpdatePortfolio.run(user: current_user, portfolio: portfolio_params)
    if result.success?
      render json: result.portfolio
    else
      render json: {error: result.error}, status: :unprocessable_entity
    end
  end

  # PATCH /api/portfolios/amount/1
  # payload: {portfolio_id: 1, change_in_balance: -10}
  def change_cash_balance
    result = AddRemoveMoneyFromPortfolio.run(
      {user_id: current_user.id}.merge(portfolio_cash_params))
    if result.success?
      render json: result.portfolio
    else
      render json: {error: result.error}, status: :unprocessable_entity
    end
  end

  private

  def portfolio_params
    res = params.require(:portfolio).permit(:nickname, :cash_balance, :id)
    res.merge(params.permit(:id)).symbolize_keys
  end

  def portfolio_cash_params
    params.permit(:portfolio_id, :change_in_balance).symbolize_keys
  end
end