class AddNewColumnsToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :start_date, :datetime
    add_column :projects, :deadline, :datetime
  end
end
