class CreateConfirmationCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :confirmation_codes do |t|
      t.string    :confirmation_token
      t.string    :sms_code
      t.integer   :retry_count
      t.datetime  :generation_time
      t.integer   :failed_attempts_count
      t.references :user_account, null: false, index: true, foreign_key: {to_table: :user_accounts}
      t.references :confirmation_type, null: false, index: true, foreign_key: {to_table: :confirmation_types}
    end
  end
end
