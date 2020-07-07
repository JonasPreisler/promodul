class CustomerType < ApplicationRecord
  validates :id_name, length: { maximum: 150 }
end
