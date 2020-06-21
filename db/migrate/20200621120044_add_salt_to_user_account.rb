class AddSaltToUserAccount < ActiveRecord::Migration[5.2]
  def up
    add_column :user_accounts, :salt, :string
  end

  def down
    remove_column :user_accounts, :salt
  end
end
