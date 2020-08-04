class ConfirmationCode < ApplicationRecord

  validates :sms_code,            length: { maximum: 12 }
  validates :retry_count,         null: false
  validates :generation_time,     presence: true
  validates :user_account_id,     presence: true,                           numericality: { only_integer: true }

  belongs_to :user_account

  belongs_to :confirmation_type, optional: true

  has_secure_token :confirmation_token
end
