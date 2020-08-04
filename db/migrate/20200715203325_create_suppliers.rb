class CreateSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :suppliers do |t|
      t.datetime :registration_date
      t.boolean :active
      t.references :integration_system, foreign_key: true,  null: false
      t.references :business_type, foreign_key: true,  null: false
      t.string :name, null: false
      t.string :identification_code, null: false
      t.string :phone_number
    end
  end
end
