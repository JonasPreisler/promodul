class SupplierProductPrice < ApplicationRecord
  belongs_to :supplier_product

  validates :supplier_product_id,  presence: true
  validates :price,                presence: true
end
