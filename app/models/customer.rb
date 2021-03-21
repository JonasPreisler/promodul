class Customer < ApplicationRecord
  include Validations::ModelValidation

  belongs_to :user_account, class_name: 'UserAccount'
end
