class RemoveAndAddColumnsFroCurrency < ActiveRecord::Migration[5.2]
  def up
    remove_column :supplier_product_prices, :currency
    add_column :supplier_product_prices, :currency_id, :integer
    add_foreign_key :supplier_product_prices, :currencies, column: :currency_id
    add_index :supplier_product_prices, :currency_id, name: :supplier_product_prices_currency
  end

  def down
    remove_foreign_key :supplier_product_prices, :currencies
    remove_index :supplier_product_prices, name: :supplier_product_prices_currency
    remove_column :supplier_product_prices, :currency_id
    add_column :supplier_product_prices, :currency, :string
  end
end

