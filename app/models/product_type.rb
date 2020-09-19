class ProductType < ApplicationRecord
  multilanguage [:name]

  validates :name,    presence: true
  validates :id_name, presence: true
end
