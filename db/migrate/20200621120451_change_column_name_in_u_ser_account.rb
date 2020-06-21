class ChangeColumnNameInUSerAccount < ActiveRecord::Migration[5.2]
  def up
    rename_column :user_accounts, :encrypted_password, :crypted_password
  end

  def down
    rename_column :user_accounts, :crypted_password, :encrypted_password
  end
end
