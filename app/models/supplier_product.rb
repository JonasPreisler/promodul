class SupplierProduct < ApplicationRecord
  belongs_to :supplier
  belongs_to :product

  has_one :supplier_product_price, dependent: :destroy
  accepts_nested_attributes_for :supplier_product_price, allow_destroy: true

  has_one :product_characteristic, through: :product
end
