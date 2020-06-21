class CreateUserAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_accounts do |t|
      t.string   :first_name,           null: false, limit: 50
      t.string   :last_name,            null: false, limit: 50
      t.datetime :birth_date,           null: false
      t.string   :phone_number,         null: false
      t.string   :email,                null: false
      t.string   :encrypted_password,   null: false, limit: 255
      t.boolean  :active,               null: false,                default: false
      t.integer  :failed_logins_count
      t.date     :last_attempt_date
      t.boolean  :locked,               null: false,                default: false
      t.timestamps
    end
  end
end
