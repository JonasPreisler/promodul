class CreateUserAccountTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_account_tasks do |t|
      t.references  :user_account,     foreign_key: true, null: false
      t.references  :task,     foreign_key: true, null: false
      t.timestamps
    end
  end
end
