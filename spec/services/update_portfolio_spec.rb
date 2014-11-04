require 'spec_helper'

describe UpdatePortfolio do

  context "user not signed in"  do
    let(:guest_user) {User.get_guest_user}

    it "returns an error for no user" do
      result = UpdatePortfolio.run
      expect(result.success?).to eq(false)
      expect(result.error).to eq("User needs to be logged in")
    end

    it "returns an error for a guest user" do
      result = UpdatePortfolio.run({user: guest_user})
      expect(result.success?).to eq(false)
      expect(result.error).to eq("User needs to be logged in")
    end
  end

  context "user is signed in" do
    let(:user) {User.create(full_name: "Test Person", guest: false)}

    context "No proper Portfolio is given" do
      it "returns an error for no portfolio given" do
        result = UpdatePortfolio.run(user: user)
        expect(result.success?).to eq(false)
        expect(result.error).to eq("Need a portfolio id to run")
      end

      it "returns an error for no portfolio id given" do
        result = UpdatePortfolio.run(
          user: user,
          portfolio: {}
        )
        expect(result.success?).to eq(false)
        expect(result.error).to eq("Need a portfolio id to run")
      end

      it "returns an error if the portfolio doesn't exist" do
        result = UpdatePortfolio.run(
          user: user,
          portfolio: {id: -1})
        expect(result.success?).to eq(false)
        expect(result.error).to eq("Portfolio with the given id was not found")
      end
    end

    context "Portfolio does not belong to user" do
      let(:user2) {User.create(full_name: "Test Person 2", guest: false)}
      let!(:p2) do
        Portfolio.create_for_user(
          user: user2,
          nickname: "Second",
          cash_balance: 1000).portfolio
      end

      it "returns an error if the portfolio doesn't belong to the user" do
        result = UpdatePortfolio.run(
          user: user,
          portfolio: {id: p2.id})
        expect(result.success?).to eq(false)
        expect(result.error).to eq("Portfolio with the given id does not belong to you")
      end
    end

    context "Proper portfolio is given with proper user" do
      let!(:p1) do
        Portfolio.create_for_user(
          user: user,
          nickname: "First",
          cash_balance: 1000).portfolio
      end

      it "updates the portfolio nickname" do
        result = UpdatePortfolio.run(
          user: user,
          portfolio: {
            id: p1.id,
            nickname: "First Edited"
        })
        expect(result.success?).to eq(true)
        expect(result.portfolio.id).to eq(p1.id)
        expect(result.portfolio.nickname).to eq("First Edited")
        expect(Portfolio.find(p1.id).nickname).to eq("First Edited")
      end

      it "doesn't allow you to change your balance" do
        result = UpdatePortfolio.run(
          user: user,
          portfolio: {
            id: p1.id,
            nickname: "First Edited",
            cash_balance: 10000
        })
        expect(result.success?).to eq(false)
        expect(result.error).to eq("Cannot directly change cash balance")
      end
    end
  end
end