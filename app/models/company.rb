class Company < ApplicationRecord
  has_one_attached :logo
  has_one :company_logo
  has_many :user_accounts

  #has_many :sub_companies, class_name: 'Company', foreign_key: 'parent_id', dependent: :destroy
  #belongs_to :country
  #belongs_to :city
  #has_many :departments, dependent: :destroy
end
