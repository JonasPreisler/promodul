class SupplierProductPrice < ApplicationRecord
  belongs_to :supplier_product
  belongs_to :currency

  validates :supplier_product_id,  presence: true
  validates :price,                presence: true
  validates :currency_id,          presence: true
end
