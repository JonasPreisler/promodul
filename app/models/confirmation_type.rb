class ConfirmationType < ApplicationRecord
  validates :name,    length: { maximum: 150 }
  validates :id_name, length: { maximum: 150 }
end
