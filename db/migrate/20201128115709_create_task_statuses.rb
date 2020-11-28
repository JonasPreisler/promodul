class CreateTaskStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :task_statuses do |t|
      t.json :name,    null: false
      t.string :id_name, null: false
    end
  end
end
