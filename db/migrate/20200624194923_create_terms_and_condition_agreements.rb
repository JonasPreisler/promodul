class CreateTermsAndConditionAgreements < ActiveRecord::Migration[5.2]
  def change
    create_table :terms_and_condition_agreements do |t|
      t.references :user_account, foreign_key: true, null: false
      t.references :terms_and_condition, foreign_key: true, null: false
      t.datetime :agreed_date
    end
  end
end
