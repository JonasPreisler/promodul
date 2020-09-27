class SupplierProduct < ApplicationRecord
  belongs_to :supplier
  belongs_to :product

  has_one :supplier_product_price, dependent: :destroy
  accepts_nested_attributes_for :supplier_product_price, allow_destroy: true

  has_one :product_characteristic, through: :product

  validates :provider_id,             presence: true
  validates :med_code,                presence: true, length: { maximum: 50 }
  validates :medicament_id,           presence: true
  validates :divisible_frequency,     presence: true, if: :is_divisible, :numericality => { greater_than: 0 }
  validates :min_sell_amount,         presence: true,                    :numericality => { greater_than: 0 }

end
