class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :city_code, null: false
      t.references :country, null: false, index: true, foreign_key: {to_table: :countries}
    end
  end
end
