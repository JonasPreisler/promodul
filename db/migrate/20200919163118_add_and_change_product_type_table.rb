class AddAndChangeProductTypeTable < ActiveRecord::Migration[5.2]
  def up
    change_column :product_types, :name, :json,  using: 'name::json'
    add_column :product_types, :active, :boolean, default: true
  end

  def down
    change_column :product_types, :name, :string
    remove_column :product_types, :active
  end
end
