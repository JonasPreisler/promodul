class Resource < ApplicationRecord
  validates :resource_type_id, presence: true
  validates :name, presence: true
  validates :description, presence: true

  belongs_to :model_on, polymorphic: true
  belongs_to :resource_type
  belongs_to :company

  has_many :attachments, as: :attached_on
  has_many :task_resources
  has_many :project_resources

  #has_one :provider_policy_picture, class_name: 'ProviderPolicyPicture', foreign_key: 'provider_id'
end
