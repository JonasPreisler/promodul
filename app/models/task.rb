class Task < ApplicationRecord
  belongs_to :user_account
  belongs_to :product
  belongs_to :task_status
  belongs_to :order
end
