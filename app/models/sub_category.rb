class SubCategory < ApplicationRecord
  multilanguage [:name]

  belongs_to :category
end
