class AddColumnsToCompany < ActiveRecord::Migration[5.2]
  def up
    add_reference :companies,:countries, foreign_key: true, index: true
    add_reference :companies,:cities, foreign_key: true, index: true
    add_column :companies, :parent_id, :integer, null: true, index: true
    add_foreign_key :companies, :companies, column: :parent_id
  end

  def down
    remove_reference :companies, :countries
    remove_reference :companies, :cities
    remove_column :companies, :parent_id
  end
end