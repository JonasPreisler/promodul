class CreateUserRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_roles do |t|
      t.references :user_account, foreign_key: true, null: false
      t.references :role_group, foreign_key: true, null: false
    end
  end
end
