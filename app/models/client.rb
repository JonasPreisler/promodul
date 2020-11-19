class Client < ApplicationRecord
  belongs_to :user_account
  belongs_to :country
  belongs_to :city
  belongs_to :clients_group
  belongs_to :clients_type
  belongs_to :currency
end
