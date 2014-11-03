require 'ostruct'

class Portfolio < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :nickname, :cash_balance

  def self.create_for_user(params={})
    if params[:user].nil? || params[:user].guest
      return OpenStruct.new(
        success?: false,
        error: "Need user to create portfolio"
      )
    end

    if params[:cash_balance].nil? || params[:nickname].nil?
      return OpenStruct.new(
        success?: false,
        error: "Need nickname and cash amount to create portfolio"
      )
    end

    user = params[:user]
    portfolio = user.portfolios.build(
      nickname: params[:nickname],
      cash_balance: params[:cash_balance])

    portfolio.save

    return OpenStruct.new(
      success?: true,
      portfolio: portfolio)
  end
end
