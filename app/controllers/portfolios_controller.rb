class PortfoliosController < ApplicationController
  def create
    result = Portfolio.create_for_user(portfolio_params.merge({user: current_user}))
    if result.success?
      render json: result.portfolio
    else
      render json: {status: :unprocessable_entity, error: result.error}
    end
  end

  def index
  end

  def update
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:nickname, :cash_balance)
  end
end