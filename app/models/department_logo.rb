class DepartmentLogo < ApplicationRecord
  before_save :refresh_uuid
  mount_uploader :logo, DepartmentLogoUploader

  belongs_to :department

  def refresh_uuid
    (self.uuid = SecureRandom.uuid) if self.logo_changed?
  end
end
