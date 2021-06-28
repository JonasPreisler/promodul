class AddNewColumnToCompany < ActiveRecord::Migration[5.2]
  def up
    add_column :companies, :legal_entity, :string
  end

  def down
    remove_column :companies, :legal_entity
  end
end
