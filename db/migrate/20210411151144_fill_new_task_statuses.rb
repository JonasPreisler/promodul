class FillNewTaskStatuses < ActiveRecord::Migration[5.2]
  def up
    TaskStatus.create(name: "Open", id_name: :open)
    TaskStatus.create(name: "In progress", id_name: :in_progress)
    TaskStatus.create(name: "Done", id_name: :done)
    TaskStatus.create(name: "Canceled", id_name: :canceled)
  end

  def down
    TaskStatus.where(id_name: [:open, :in_progress, :done, :canceled]).delete_all
  end
end
