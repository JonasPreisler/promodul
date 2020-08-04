class CreateCustomerTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :customer_types do |t|
      t.string :name
      t.string :id_name
    end
  end
end
