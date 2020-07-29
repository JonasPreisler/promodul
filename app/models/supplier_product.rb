class SupplierProduct < ApplicationRecord
  belongs_to :supplier
  belongs_to :product

  has_one :supplier_product_price
  has_one :product_characteristic, through: :product
  #has_many :supplier_product_balances

  validates :provider_id,             presence: true
  validates :med_code,                presence: true, length: { maximum: 50 }
  validates :medicament_id,           presence: true
  validates :divisible_frequency,     presence: true, if: :is_divisible, :numericality => { greater_than: 0 }
  validates :min_sell_amount,         presence: true,                    :numericality => { greater_than: 0 }


  before_validation :set_min_sell_amount

  def set_min_sell_amount
    if self.is_divisible
      self.min_sell_amount = self.product.product_characteristic.numerus / self.divisible_frequency
    else
      self.min_sell_amount = self.product.product_characteristic.numerus
    end
  end
end
