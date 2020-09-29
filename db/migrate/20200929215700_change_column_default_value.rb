class ChangeColumnDefaultValue < ActiveRecord::Migration[5.2]
  def up
    change_column :supplier_products, :is_active, :boolean,  default: true
  end

  def down
    change_column :supplier_products, :is_active, :boolean,  default: false
  end
end