class Resource < ApplicationRecord
  validates :resource_type_id, presence: true
  validates :name, presence: true
  validates :description, presence: true

  belongs_to :model_on, polymorphic: true
  belongs_to :resource_type

  #has_one :provider_policy_picture, class_name: 'ProviderPolicyPicture', foreign_key: 'provider_id'
end
