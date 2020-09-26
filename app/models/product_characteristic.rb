class ProductCharacteristic < ApplicationRecord
  belongs_to :product
  belongs_to :product_type,                                                           optional: true
  belongs_to :product_vat_type,                                                       optional: true
  belongs_to :sub_category, class_name: 'SubCategory', foreign_key: :sub_category_id, optional: true

  validates :volume,       length: { maximum: 200 }
  validates :manufacturer, length: { maximum: 200 }
end