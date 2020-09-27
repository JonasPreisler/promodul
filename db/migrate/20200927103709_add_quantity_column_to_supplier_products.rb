class AddQuantityColumnToSupplierProducts < ActiveRecord::Migration[5.2]
  def up
    add_column :supplier_products, :quantity, :integer
  end

  def down
    remove_column :supplier_products, :quantity
  end
end
