class AddColumnToCompany < ActiveRecord::Migration[5.2]
  def up
    add_column :companies, :active, :boolean, default: true
  end

  def down
    remove_column :companies, :active
  end
end
