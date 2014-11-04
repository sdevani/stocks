require 'spec_helper'

describe AddRemoveMoneyFromPortfolio do
  let(:user) {User.create(full_name: "Test Person", guest: false)}

  let!(:portfolio) do
    Portfolio.create_for_user(
      user: user,
      nickname: "First",
      cash_balance: 1000).portfolio
  end

  it "requires proper user_id, portfolio_id" do
    result = AddRemoveMoneyFromPortfolio.run()
    expect(result.success?).to eq(false)
    expect(result.error).to eq("Need user and portfolio id to make transaction")
  end

  it "requires the user to own the portfolio" do
    user2 = User.create(full_name: "Test2", guest: false)
    result = AddRemoveMoneyFromPortfolio.run(
      user_id: user2.id,
      portfolio_id: portfolio.id
    )
    expect(result.success?).to eq(false)
    expect(result.error).to eq("Given user does not own the portfolio")
  end

  it "requires an amount to withdraw or deposit" do
    result = AddRemoveMoneyFromPortfolio.run(
      user_id: user.id,
      portfolio_id: portfolio.id
    )
    expect(result.success?).to eq(false)
    expect(result.error).to eq("Need monetary amount to withdraw or deposit")
  end

  it "can't withdraw more money than it has" do
    result = AddRemoveMoneyFromPortfolio.run(
      user_id: user.id,
      portfolio_id: portfolio.id,
      change_in_balance: -2000
    )
    expect(result.success?).to eq(false)
    expect(result.error).to eq("Can't withdraw more money than you have")
  end

  it "allows you to withdraw money" do
    result = AddRemoveMoneyFromPortfolio.run(
      user_id: user.id,
      portfolio_id: portfolio.id,
      change_in_balance: -700
    )
    expect(result.success?).to eq(true)
    expect(result.portfolio.cash_balance).to eq(300)
    saved_portfolio = Portfolio.find(portfolio.id)
    expect(saved_portfolio.cash_balance).to eq(300)
  end

  it "allows you to deposit money" do
    result = AddRemoveMoneyFromPortfolio.run(
      user_id: user.id,
      portfolio_id: portfolio.id,
      change_in_balance: 200
    )
    expect(result.success?).to eq(true)
    expect(result.portfolio.cash_balance).to eq(1200)
    saved_portfolio = Portfolio.find(portfolio.id)
    expect(saved_portfolio.cash_balance).to eq(1200)
  end
end