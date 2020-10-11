class Company < ApplicationRecord
  has_many :sub_companies, class_name: 'Company', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :country
  belongs_to :city
  has_many :departments, dependent: :destroy
end
