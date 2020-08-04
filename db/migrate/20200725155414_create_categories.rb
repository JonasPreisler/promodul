class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.json    :name,                                 null: false
      t.string  :id_name,                                           limit: 50
      t.boolean :active,                               null: false,           default: true
    end
  end
end
