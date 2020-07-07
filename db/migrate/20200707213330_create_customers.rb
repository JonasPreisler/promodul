class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string    :name,              null: false, limit: 50
      t.string    :delivery_address
      t.datetime  :invoice_address
      t.boolean   :active,            null: false, default: :false
      t.integer   :user_account_id
      t.integer   :customer_type_id,  null: false
      t.string    :legal_id
      t.timestamps
    end
  end
end
