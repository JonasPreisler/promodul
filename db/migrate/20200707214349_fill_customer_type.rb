class FillCustomerType < ActiveRecord::Migration[5.2]
  def up
    CustomerType.create!(name: "Private Customer",        id_name: :private_customer)
    CustomerType.create!(name: "Business Customer",       id_name: :business_customer)
    CustomerType.create!(name: "Multi Business Customer", id_name: :multi_business_customer)
  end

  def down
    CustomerType.where(id_name: [:private_customer, :business_customer, :multi_business_customer]).delete_all
  end
end
