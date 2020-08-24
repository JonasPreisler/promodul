class CreateProductVatTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :product_vat_types do |t|
      t.string :name,    null: false
      t.string :id_name, null: false
    end
  end
end
