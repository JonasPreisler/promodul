class RemoveCustomerType < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :customers, :customer_types
  end
end
