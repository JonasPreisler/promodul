class CreateProductImages < ActiveRecord::Migration[5.2]
  def change
    create_table :product_images do |t|
      t.references :product, foreign_key: true, null: false
      t.string     :image,   limit: 50
      t.uuid       :uuid,                       null: false
    end

    add_index :product_images, :uuid, unique: true
  end
end