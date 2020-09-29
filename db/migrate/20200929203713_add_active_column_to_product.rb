class AddActiveColumnToProduct < ActiveRecord::Migration[5.2]
  def up
    add_column :products, :active, :boolean, default: true
  end

  def down
    remove_column :products, :active
  end
end
