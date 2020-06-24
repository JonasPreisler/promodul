class TermsAndConditionAgreement < ApplicationRecord
  belongs_to :user_account,         class_name: 'UserAccount',        foreign_key: :user_account_id
  belongs_to :terms_and_condition,  class_name: 'TermsAndCondition',  foreign_key: :terms_and_condition_id
end
