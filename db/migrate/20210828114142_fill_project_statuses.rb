class FillProjectStatuses < ActiveRecord::Migration[5.2]
  def up
    ProjectStatus.create!(name: "Open",   id_name: :open)
    ProjectStatus.create!(name: "In progress",   id_name: :in_progress)
    ProjectStatus.create!(name: "Done",  id_name: :done)
    ProjectStatus.create!(name: "Reactivated",  id_name: :reactivated)
  end

  def down
    ProjectStatus.where(id_name: [:open, :in_progress, :done, :reactivated]).delete_all
  end
end
