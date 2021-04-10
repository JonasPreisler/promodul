class Project < ApplicationRecord
  belongs_to :user_account, optional: true
end
