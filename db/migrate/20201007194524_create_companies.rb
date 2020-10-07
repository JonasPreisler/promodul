class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name,         null: false
      t.string :description
      t.string :address
      t.string :phone_number
    end
  end
end
