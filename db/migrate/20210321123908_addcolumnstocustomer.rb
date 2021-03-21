class Addcolumnstocustomer < ActiveRecord::Migration[5.2]
  def up
    add_column :user_accounts, :first_name, :string
    add_column :user_accounts, :last_name, :string
    add_column :user_accounts, :birth_date, :datetime
  end

  def down
    remove_column :user_accounts, :first_name
    remove_column :user_accounts, :last_name
    remove_column :user_accounts, :birth_date
  end
end
