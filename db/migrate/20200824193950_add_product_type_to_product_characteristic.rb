class AddProductTypeToProductCharacteristic < ActiveRecord::Migration[5.2]
  def up
    add_column :product_characteristics,  :product_type_id, :integer
    add_index :product_characteristics,   :product_type_id
  end

  def down
    remove_index  :product_characteristics,  :product_type_id
    remove_column :product_characteristics,  :product_type_id
  end
end
