class CountryPhoneIndex < ApplicationRecord
  validates :iso_code,              presence: true, length: { maximum: 2 }
  validates :phone_index,           presence: true, length: { maximum: 10 }
end
