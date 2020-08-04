class Category < ApplicationRecord
  multilanguage [:name]

  has_many :sub_categories
end
