class AddProjectStatusesToProject < ActiveRecord::Migration[5.2]
  def up
    add_column :projects, :project_status_id, :integer
    add_foreign_key :projects, :project_statuses, column: :project_status_id
  end

  def down
    remove_foreign_key :projects, :project_statuses
    remove_column :projects, :project_status_id
  end
end
