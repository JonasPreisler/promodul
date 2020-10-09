class Department < ApplicationRecord
  has_many :sub_departments, class_name: 'Department', foreign_key: 'parent_id'
  belongs_to :country
  belongs_to :city
  belongs_to :company
end
