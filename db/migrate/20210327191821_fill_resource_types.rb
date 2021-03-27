class FillResourceTypes < ActiveRecord::Migration[5.2]
  def up
    ResourceType.create(name: "Machine", id_name: :machine)
    ResourceType.create(name: "Tool", id_name: :tool)
    ResourceType.create(name: "External Resource", id_name: :external_resource)
  end

  def down
    ResourceType.where(id_name: [:machine, :tool, :external_resource]).delete_all
  end
end
