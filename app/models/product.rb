class Product < ApplicationRecord
  multilanguage [:name]
  multilanguage [:full_name]

  has_one :product_characteristic, dependent: :destroy
  has_many :supplier_products

  #has_many :product_images, dependent: :destroy
  accepts_nested_attributes_for :product_characteristic, allow_destroy: true


  validates :name,            presence: true
  validates :full_name,       presence: true
  validates :code,        length: { maximum: 50 }
end
