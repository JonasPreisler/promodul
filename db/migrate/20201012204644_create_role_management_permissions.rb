class CreateRoleManagementPermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :role_management_permissions do |t|
      t.references :role_group, foreign_key: true, null: false
      t.boolean :show_data, default: false
      t.boolean :read_data, default: false
      t.boolean :create_data, default: false
      t.boolean :edit_data, default: false
      t.boolean :delete_record, default: false
      t.boolean :activate_data, default: false
    end
  end
end
