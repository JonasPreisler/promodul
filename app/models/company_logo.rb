class CompanyLogo < ApplicationRecord
  before_save :refresh_uuid
  mount_uploader :logo, CompanyLogoUploader

  belongs_to :company

  def refresh_uuid
    (self.uuid = SecureRandom.uuid) if self.logo_changed?
  end
end
