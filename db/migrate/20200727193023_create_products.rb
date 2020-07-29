class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.json    :name,        null: false
      t.json    :full_name,   null: false
      t.string  :description, null: false
      t.string  :code,        null: false
    end

    add_index :products, :code, unique: true
  end
end
