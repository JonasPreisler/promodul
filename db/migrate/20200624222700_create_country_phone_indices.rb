class CreateCountryPhoneIndices < ActiveRecord::Migration[5.2]
  def change
    create_table :country_phone_indices do |t|
      t.string :iso_code, null: false, limit: 2
      t.string :phone_index, null: false, limit: 10
      t.integer :length_limit, default: 9, null: false
    end
  end
end
