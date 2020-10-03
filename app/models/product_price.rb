class ProductPrice < ApplicationRecord
  belongs_to :product

  validates :list_price_type,     presence: true
  validates :list_price_amount,   presence: true
  validates :manufacturing_cost,  presence: true
end
