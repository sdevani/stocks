require 'spec_helper'

describe Portfolio do
  describe "#create_for_user" do
    let(:guest_user) {User.get_guest_user}
    let(:user) {User.create(full_name: "Test Person", guest: false)}

    it "requires a user" do
      result = Portfolio.create_for_user()
      expect(result.success?).to eq(false)
      expect(result.error).to eq("Need user to create portfolio")
    end

    it "requires a signed up user" do
      result = Portfolio.create_for_user(user: guest_user)
      expect(result.success?).to eq(false)
      expect(result.error).to eq("Need user to create portfolio")
    end

    it "requires a name and cash amount" do
      result = Portfolio.create_for_user(user: user)
      expect(result.success?).to eq(false)
      expect(result.error).to eq("Need nickname and cash amount to create portfolio")
    end

    it "creates a portfolio associated with a user" do
      old_portfolio_count = Portfolio.count

      result = Portfolio.create_for_user(
        user: user,
        nickname: "My Portfolio",
        cash_balance: 1000)

      expect(result.success?).to eq(true)
      expect(result.portfolio).to be_a(Portfolio)
      expect(result.portfolio.user.id).to eq(user.id)
      expect(result.portfolio.cash_balance).to eq(1000)
      expect(result.portfolio.nickname).to eq("My Portfolio")
      expect(user.portfolios[0].id).to eq(result.portfolio.id)

      expect(Portfolio.count).to eq(old_portfolio_count + 1)
    end
  end
end