class Customer < ApplicationRecord
  include Validations::ModelValidation

  belongs_to :user_account, class_name: 'UserAccount'
  belongs_to :customer_type,class_name: 'CustomerType'


  validates :name,                           presence: true, length: { maximum: 50 }
  validates :delivery_address,               presence: true, length: { maximum: 500 }

  validates_uniqueness_of :invoice_address,  scope: [:user_account_id, :active], if: Proc.new {|n| n.active && n.invoice_address.present? }
  validates_uniqueness_of :customer_type_id, scope: [:user_account_id, :active], if: Proc.new {|n| n.active && (n.customer_type.id_name.eql?('business_customer') || n.customer_type.id_name.eql?('private_customer'))}

  def is_private?
    self.customer_type.id_name.eql?("private_customer")
  end

  def is_business?
    self.customer_type.id_name.eql?("business_customer")
  end

  def is_multi_business
    self.customer_type.id_name.eql?("multi_business_customer")
  end
end
