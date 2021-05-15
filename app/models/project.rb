class Project < ApplicationRecord
  belongs_to :user_account, optional: true
  has_many :attachments, as: :attached_on

  has_many :user_account_projects
  accepts_nested_attributes_for :user_account_projects, allow_destroy: true
  has_many :project_resources
  accepts_nested_attributes_for :project_resources, allow_destroy: true
end
