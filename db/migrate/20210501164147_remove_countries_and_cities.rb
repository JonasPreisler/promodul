class RemoveCountriesAndCities < ActiveRecord::Migration[5.2]
  def up
    remove_reference :companies, :country
    remove_reference :companies, :city
  end

  def down
    add_reference :companies,:country, foreign_key: true, index: true
    add_reference :companies,:city, foreign_key: true, index: true
  end
end
