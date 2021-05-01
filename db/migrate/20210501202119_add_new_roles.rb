class AddNewRoles < ActiveRecord::Migration[5.2]
  def up
    RoleGroup.create(name: "Super Admin", id_name: :super_admin)
    RoleGroup.create(name: "Project Manager", id_name: :project_manager)
    RoleGroup.create(name: "Employee", id_name: :employee)
  end

  def down
    RoleGroup.where(id_name: [:super_admin, :project_manager, :employee]).delete_all
  end
end
