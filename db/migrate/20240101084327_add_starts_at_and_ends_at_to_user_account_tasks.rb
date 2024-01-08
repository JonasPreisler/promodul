class AddStartsAtAndEndsAtToUserAccountTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :user_account_tasks, :starts_at, :datetime
    add_column :user_account_tasks, :ends_at, :datetime
  end
end
