class CreateRoleGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :role_groups do |t|
      t.string :name, null: false
      t.string :id_name, null:false
      t.timestamps
    end
  end
end
