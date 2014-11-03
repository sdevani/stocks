class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.references :user
      t.decimal :cash_balance
      t.string :nickname

      t.timestamps
    end
  end
end
