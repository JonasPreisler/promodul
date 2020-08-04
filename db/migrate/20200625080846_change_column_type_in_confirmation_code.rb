class ChangeColumnTypeInConfirmationCode < ActiveRecord::Migration[5.2]
  def up
    change_column :confirmation_codes, :retry_count, :integer
  end

  def down
    change_column :confirmation_codes, :retry_count, :integer
  end
end
