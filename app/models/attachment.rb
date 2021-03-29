class Attachment < ApplicationRecord
  before_save :refresh_uuid
  mount_uploader :file, AttachedUploader

  #has_many :resources, as: :attached_on

  #belongs_to :product

  def refresh_uuid
    (self.uuid = SecureRandom.uuid) if self.file_changed?
  end
end
