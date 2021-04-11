class Task < ApplicationRecord
  has_many :user_account_tasks
  accepts_nested_attributes_for :user_account_tasks, allow_destroy: true
  has_many :task_resources
  accepts_nested_attributes_for :task_resources, allow_destroy: true
  belongs_to :task_status
  belongs_to :project
end
