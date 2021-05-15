class CreateProjectResources < ActiveRecord::Migration[5.2]
  def change
    create_table :project_resources do |t|
      t.references  :resource,     foreign_key: true, null: false
      t.references  :project,     foreign_key: true, null: false
      t.timestamps
    end
  end
end
