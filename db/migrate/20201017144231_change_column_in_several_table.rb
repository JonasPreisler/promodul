class ChangeColumnInSeveralTable < ActiveRecord::Migration[5.2]
  def up
    add_column :product_group_permissions,   :no_access, :boolean, default: true
    add_column :product_type_permissions,    :no_access, :boolean, default: true
    add_column :product_import_permissions,  :no_access, :boolean, default: true
    add_column :product_catalog_permissions, :no_access, :boolean, default: true
    add_column :suppliers_permissions,       :no_access, :boolean, default: true
    add_column :company_permissions,         :no_access, :boolean, default: true
    add_column :system_data_permissions,          :no_access, :boolean, default: true
    add_column :user_management_permissions, :no_access, :boolean, default: true
    add_column :role_management_permissions, :no_access, :boolean, default: true


    remove_column :product_group_permissions, :show_data
    remove_column :product_type_permissions, :show_data
    remove_column :product_import_permissions, :show_data
    remove_column :product_catalog_permissions, :show_data
    remove_column :suppliers_permissions, :show_data
    remove_column :company_permissions, :show_data
    remove_column :system_data_permissions, :show_data
    remove_column :user_management_permissions, :show_data
    remove_column :role_management_permissions, :show_data
  end

  def down
    remove_column :product_group_permissions, :no_access
    remove_column :product_type_permissions, :no_access
    remove_column :product_import_permissions, :no_access
    remove_column :product_catalog_permissions, :no_access
    remove_column :suppliers_permissions, :no_access
    remove_column :company_permissions, :no_access
    remove_column :system_data_permissions, :no_access
    remove_column :user_management_permissions, :no_access
    remove_column :role_management_permissions, :no_access

    add_column :product_group_permissions,   :show_data, :boolean, default: false
    add_column :product_type_permissions,    :show_data, :boolean, default: false
    add_column :product_import_permissions,  :show_data, :boolean, default: false
    add_column :product_catalog_permissions, :show_data, :boolean, default: false
    add_column :suppliers_permissions,       :show_data, :boolean, default: false
    add_column :company_permissions,         :show_data, :boolean, default: false
    add_column :system_data_permissions,          :show_data, :boolean, default: false
    add_column :user_management_permissions, :show_data, :boolean, default: false
    add_column :role_management_permissions, :show_data, :boolean, default: false
  end
end
