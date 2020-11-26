class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product
  multilanguage [:name, :full_name]
  
end
