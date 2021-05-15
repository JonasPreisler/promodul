class UserAccountProject < ApplicationRecord
  belongs_to :project
  belongs_to :user_account
end
