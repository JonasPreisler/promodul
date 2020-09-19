class ProductImage < ApplicationRecord
  before_save :refresh_uuid
  mount_uploader :image, ProductImageUploader

  belongs_to :product

  def refresh_uuid
    (self.uuid = SecureRandom.uuid) if self.image_changed?
  end
end
