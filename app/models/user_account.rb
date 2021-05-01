class UserAccount < ApplicationRecord
  include Validations::ModelValidation
  authenticates_with_sorcery!

  before_save { self.username.downcase! }
  before_save { self.email&.downcase! }

  validate options(:valid_password_format?,    :password)
  validate options(:valid_email_format?,       :email),         if: Proc.new { |n| n.email && !n.email&.empty? }

  validates :phone_number,     presence: true, length: { maximum: 12 }
  validates :first_name,     presence: true, length: { maximum: 12 }
  validates :last_name,     presence: true, length: { maximum: 12 }
  validates :email,            presence: true
  validates :crypted_password, presence: true, length: { maximum: 255 }
  validates :phone_number_iso,        presence: true, length:  { maximum: 2 }

  has_one :user_role
  has_one :user_permission
  has_one :customer
  has_many :confirmation_code, class_name: 'ConfirmationCode', foreign_key: :user_account_id, dependent: :destroy
  has_many :terms_and_condition_agreements, dependent: :destroy, class_name: 'TermsAndConditionAgreement', foreign_key: :user_account_id

  has_many :attachments, as: :attached_on
  has_many :user_account_tasks
end
