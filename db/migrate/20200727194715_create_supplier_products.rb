class CreateSupplierProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :supplier_products do |t|
      t.references :supplier, foreign_key: true, null: false
      t.references :product, foreign_key: true, null: false
      t.string :supplier_code
      t.boolean :is_active, default: false
      t.integer :min_sell_amount
      t.timestamps
    end
  end
end
