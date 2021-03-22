class CreateExternalResourceTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :external_resource_types do |t|
      t.string :name,    limit: 150
      t.string :id_name, limit: 150
    end
  end
end
