class FillCurrencies < ActiveRecord::Migration[5.2]
  def up
    Currency.create!(name: "Krone", symbol: "‎KR", code: :nok)
    Currency.create!(name: "USD dollar", symbol: "$", code: :usd)
    Currency.create!(name: "Euro", symbol: "€", code: :eur)
  end

  def down
    Currency.where(code: [:nok, :usd, :euro]).delete_all
  end
end
