class RemovenotColumnsFromAccount < ActiveRecord::Migration[5.2]
  def change
    change_column :customers, :delivery_address, :string, null: true
  end
end
