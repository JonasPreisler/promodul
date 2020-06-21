class AddUsernameToUserAccount < ActiveRecord::Migration[5.2]
  def up
    add_column :user_accounts, :username, :string
  end

  def down
    remove_column :user_accounts, :username
  end
end
