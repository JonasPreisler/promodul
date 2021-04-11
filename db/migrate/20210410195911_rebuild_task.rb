class RebuildTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks,:project, foreign_key: true, index: true
    remove_reference :tasks, :user_account
    remove_reference :tasks, :order
    remove_reference :tasks, :product
    remove_column :tasks, :tracked_time
  end
end
