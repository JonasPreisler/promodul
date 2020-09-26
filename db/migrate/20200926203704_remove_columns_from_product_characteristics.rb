class RemoveColumnsFromProductCharacteristics < ActiveRecord::Migration[5.2]
  def up
    remove_column :product_characteristics, :shape
    remove_column :product_characteristics, :packaging
    remove_column :product_characteristics, :sales_start
    remove_column :product_characteristics, :sales_end
  end

  def down
    add_column :product_characteristics, :shape, :string
    add_column :product_characteristics, :packaging, :string
    add_column :product_characteristics, :sales_start, :datetime
    add_column :product_characteristics, :sales_end, :datetime
  end
end
