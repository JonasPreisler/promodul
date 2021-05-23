class AddCompanyToModels < ActiveRecord::Migration[5.2]
  def change
    add_reference :tool_models,:company, foreign_key: true, index: true
    add_reference :machine_models,:company, foreign_key: true, index: true
    add_reference :external_resource_types,:company, foreign_key: true, index: true
  end
end
