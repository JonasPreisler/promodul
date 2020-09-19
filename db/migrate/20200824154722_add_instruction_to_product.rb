class AddInstructionToProduct < ActiveRecord::Migration[5.2]
  def up
    add_column :products, :instruction, :string, limit: 500
  end

  def down
    remove_column :products, :instruction
  end
end
