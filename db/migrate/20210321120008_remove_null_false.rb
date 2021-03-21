class RemoveNullFalse < ActiveRecord::Migration[5.2]
  def change
    change_column :customers, :customer_type_id, :integer, null: true
  end
end
