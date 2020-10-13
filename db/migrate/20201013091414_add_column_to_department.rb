class AddColumnToDepartment < ActiveRecord::Migration[5.2]
  def up
    add_column :departments, :active, :boolean, default: true
  end

  def down
    remove_column :departments, :active
  end
end
