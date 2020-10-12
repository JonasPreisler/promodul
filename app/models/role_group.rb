class RoleGroup < ApplicationRecord
  validates :name, presence: true

  has_one :product_group_permission, dependent: :destroy
  accepts_nested_attributes_for :product_group_permission, allow_destroy: true

  has_one :product_type_permission, dependent: :destroy
  accepts_nested_attributes_for :product_type_permission, allow_destroy: true

  has_one :product_import_permission, dependent: :destroy
  accepts_nested_attributes_for :product_import_permission, allow_destroy: true

  has_one :product_catalog_permission, dependent: :destroy
  accepts_nested_attributes_for :product_catalog_permission, allow_destroy: true
end
