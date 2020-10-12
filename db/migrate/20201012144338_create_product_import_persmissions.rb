class CreateProductImportPersmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :product_import_permissions do |t|
      t.references :role_group, foreign_key: true, null: false
      t.boolean :show_data, default: false
      t.boolean :import, default: false
    end
  end
end
