class CreateSupplierProductPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :supplier_product_prices do |t|
      t.references :supplier_product, foreign_key: true, null: false
      t.decimal :price, null: false
      t.string :currency
      t.decimal :price_per_unit
      t.timestamps
    end
  end
end
