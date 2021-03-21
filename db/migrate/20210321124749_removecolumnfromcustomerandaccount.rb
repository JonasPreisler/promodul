class Removecolumnfromcustomerandaccount < ActiveRecord::Migration[5.2]
  def change
    change_column :customers, :name, :string, null: true
  end
end
