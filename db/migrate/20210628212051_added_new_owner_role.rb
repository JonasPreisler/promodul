class AddedNewOwnerRole < ActiveRecord::Migration[5.2]
  def up
    RoleGroup.create(name: "Owner", id_name: :owner)
  end

  def down
    RoleGroup.where(id_name: [:owner]).delete_all
  end
end
