class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.references :resource_type, foreign_key: true, null: false
      t.references :model_on, polymorphic: true, index: true
      t.string :name
      t.string :description
    end
  end
end
