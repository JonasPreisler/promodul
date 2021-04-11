class CreateTaskResources < ActiveRecord::Migration[5.2]
  def change
    create_table :task_resources do |t|
      t.references  :resource,     foreign_key: true, null: false
      t.references  :task,     foreign_key: true, null: false
      t.timestamps
    end
  end
end
