class AddColumnsToProductCharacteristics < ActiveRecord::Migration[5.2]
  def up
    add_column :product_characteristics, :subscription, :boolean, default: false
    add_column :product_characteristics, :commission,   :boolean, default: false
  end

  def down
    remove_column :product_characteristics, :subscription
    remove_column :product_characteristics, :commission
  end

end
