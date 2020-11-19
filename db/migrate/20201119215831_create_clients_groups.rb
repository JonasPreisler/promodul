class CreateClientsGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :clients_groups do |t|
      t.json :name,      null: false
      t.string :id_name, limit: 50
    end
  end
end
