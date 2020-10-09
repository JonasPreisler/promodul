class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.string :name,         null: false
      t.string :description
      t.string :address
      t.string :phone_number
      t.references :country, foreign_key: true, null: false
      t.references :city,    foreign_key: true, null: false
      t.references :company, foreign_key: true, null: false
    end
  end
end
