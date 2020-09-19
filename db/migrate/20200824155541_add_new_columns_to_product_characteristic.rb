class AddNewColumnsToProductCharacteristic < ActiveRecord::Migration[5.2]
  def up
    add_column :product_characteristics, :external_code,  :string, limit: 50
    add_column :product_characteristics, :sales_start,    :datetime
    add_column :product_characteristics, :sales_end,      :datetime
    add_column :product_characteristics, :EAN_code,       :string, limit: 50
    add_column :product_characteristics, :weight,         :decimal
    add_column :product_characteristics, :width,          :decimal
    add_column :product_characteristics, :height,         :decimal
    add_column :product_characteristics, :depth,          :decimal


  end

  def down
    remove_column :product_characteristics, :external_code
    remove_column :product_characteristics, :sales_start
    remove_column :product_characteristics, :sales_end
    remove_column :product_characteristics, :EAN_code
    remove_column :product_characteristics, :weight
    remove_column :product_characteristics, :width
    remove_column :product_characteristics, :height
    remove_column :product_characteristics, :depth
  end
end
