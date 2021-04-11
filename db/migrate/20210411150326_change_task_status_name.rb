class ChangeTaskStatusName < ActiveRecord::Migration[5.2]
  def change
    remove_column :task_statuses, :name
    add_column :task_statuses, :name, :string
  end
end
