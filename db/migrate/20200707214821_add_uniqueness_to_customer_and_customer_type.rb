class AddUniquenessToCustomerAndCustomerType < ActiveRecord::Migration[5.2]
  def up
    add_foreign_key :customers, :customer_types, column: :customer_type_id
  end

  def down
    remove_foreign_key :customers, :customer_types, column: :customer_type_id
  end
end
