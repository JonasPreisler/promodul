class BusinessType < ApplicationRecord
  validates :name,    presence: true
  validates :id_name, presence: true

  multilanguage [:name]
end
