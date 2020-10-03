class CreateProductPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :product_prices do |t|
      t.references :product,                   foreign_key: true, null: false
      t.string     :list_price_type,     null: false, limit: 30
      t.decimal    :list_price_amount,   null: false
      t.decimal    :manufacturing_cost,  null: false
      t.timestamps
    end
  end
end
