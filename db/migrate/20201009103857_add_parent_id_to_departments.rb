class AddParentIdToDepartments < ActiveRecord::Migration[5.2]
  def up
    add_column :departments, :parent_id, :integer, null: true, index: true
    add_foreign_key :departments, :departments, column: :parent_id
  end

  def down
    remove_column :departments, :parent_id
  end
end
