class AddIntegrationSystem < ActiveRecord::Migration[5.2]
  def up
    IntegrationSystem.create!(name: "manual")
  end

  def down
    IntegrationSystem.delete_all
  end
end
