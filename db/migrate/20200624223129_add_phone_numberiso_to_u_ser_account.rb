class AddPhoneNumberisoToUSerAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :user_accounts, :phone_number_iso, :string, limit: 2, null: false, default: :de
  end
end
