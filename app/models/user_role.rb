class UserRole < ApplicationRecord
  belongs_to :user_account
  belongs_to :role_group
end
