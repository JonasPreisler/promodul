class CreateSubCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_categories do |t|
      t.json    :name,                    null: false
      t.string  :id_name,                             limit: 50
      t.boolean :active,                  null: false,           default: true
      t.integer :category_id,  null: false
    end

    add_foreign_key :sub_categories, :categories, column: :category_id
  end
end