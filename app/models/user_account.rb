class UserAccount < ApplicationRecord
  include Validations::ModelValidation
  authenticates_with_sorcery!

  before_save do
    self.username.downcase!
  end

  validate options(:valid_password_format?,    :password)
  validate options(:valid_email_format?,       :email),         if: Proc.new { |n| n.email && !n.email&.empty? }
  validate options(:valid_username_format?,    :username),      if: Proc.new { |n| n.username && !n.username&.empty? }
  validate options(:valid_username_min_length?,:username),      if: Proc.new { |n| n.username && !n.username&.empty? }
  validate options(:valid_username_max_length?,:username),      if: Proc.new { |n| n.username && !n.username&.empty? }
  validate options(:valid_phone_number_length?,:phone_number),  if: Proc.new { |n| n.phone_number && !n.phone_number&.empty? }
  validate options(:valid_phone_number_format?,:phone_number),  if: Proc.new { |n| n.phone_number && !n.phone_number&.empty? }

  validates :phone_number,     presence: true, length: { maximum: 12 }
  validates :email,            presence: true
  validates :crypted_password, presence: true, length: { maximum: 255 }
end
