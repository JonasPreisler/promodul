class RoleGroup < ApplicationRecord
  validates :name, presence: true

  has_many :user_roles

  has_one :product_group_permission, dependent: :destroy
  accepts_nested_attributes_for :product_group_permission, allow_destroy: true

  has_one :product_type_permission, dependent: :destroy
  accepts_nested_attributes_for :product_type_permission, allow_destroy: true

  has_one :product_import_permission, dependent: :destroy
  accepts_nested_attributes_for :product_import_permission, allow_destroy: true

  has_one :product_catalog_permission, dependent: :destroy
  accepts_nested_attributes_for :product_catalog_permission, allow_destroy: true

  has_one :suppliers_permission, dependent: :destroy
  accepts_nested_attributes_for :suppliers_permission, allow_destroy: true

  has_one :company_permission, dependent: :destroy
  accepts_nested_attributes_for :company_permission, allow_destroy: true

  has_one :system_data_permission, dependent: :destroy
  accepts_nested_attributes_for :system_data_permission, allow_destroy: true

  has_one :role_management_permission, dependent: :destroy
  accepts_nested_attributes_for :role_management_permission, allow_destroy: true
end
