class CreateOrderTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :order_types do |t|
      t.json :name,    null: false
      t.string :id_name, null: false
    end
  end
end
