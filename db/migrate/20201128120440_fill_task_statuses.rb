class FillTaskStatuses < ActiveRecord::Migration[5.2]
  def up
    TaskStatus.create(name: {en: "Open", no: "Åpen"}, id_name: :open)
    TaskStatus.create(name: {en: "In progress", no: "I prosess"}, id_name: :in_progress)
    TaskStatus.create(name: {en: "Done", no: "Ferdig"}, id_name: :done)
    TaskStatus.create(name: {en: "Canceled", no: "avbrutt"}, id_name: :canceled)
  end

  def down
    TaskStatus.where(id_name: [:open, :in_progress, :done, :canceled]).delete_all
  end
end
