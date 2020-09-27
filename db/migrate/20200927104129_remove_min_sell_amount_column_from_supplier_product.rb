class RemoveMinSellAmountColumnFromSupplierProduct < ActiveRecord::Migration[5.2]
  def up
    remove_column :supplier_products, :min_sell_amount
  end

  def down
    add_column :supplier_products, :min_sell_amount, :integer
  end
end
