class RemovecustomerTypeId < ActiveRecord::Migration[5.2]
  def change
    remove_column :customers, :customer_type_id
  end
end
