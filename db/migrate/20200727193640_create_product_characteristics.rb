class CreateProductCharacteristics < ActiveRecord::Migration[5.2]
  def change
    create_table :product_characteristics do |t|
      t.references :product, foreign_key: true, null: false
      t.references :sub_category, foreign_key: true, null: false
      t.string :shape
      t.string :volume
      t.string :packaging
      t.string :manufacturer
      t.string :description
    end
  end
end
