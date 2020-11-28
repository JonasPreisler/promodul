class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string      :title,          null: false, limit: 50
      t.string      :description
      t.references  :task_status,    foreign_key: true, null: false
      t.references  :product,        foreign_key: true, null: false
      t.references  :order,          foreign_key: true, null: false
      t.references  :user_account,   foreign_key: true, null: true
      t.datetime    :start_time,     null: false
      t.datetime    :deadline
      t.string      :tracked_time
      t.timestamps
    end
  end
end
