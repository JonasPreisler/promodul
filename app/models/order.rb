class Order < ApplicationRecord
  belongs_to :user_account
  belongs_to :client
  belongs_to :order_type
  belongs_to :order_status

  #has_many :order_images
  #has_many :order_files
  has_many :tasks
  has_many :products
end
