class CreateIntegrationSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :integration_systems do |t|
      t.string :name
    end
  end
end
