class OrderComment < ApplicationRecord
  belongs_to :user_account
  belongs_to :order
end
