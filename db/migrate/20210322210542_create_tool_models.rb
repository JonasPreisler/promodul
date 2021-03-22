class CreateToolModels < ActiveRecord::Migration[5.2]
  def change
    create_table :tool_models do |t|
      t.string :name,    limit: 150
      t.string :id_name, limit: 150
    end
  end
end
