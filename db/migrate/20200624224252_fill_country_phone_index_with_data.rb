class FillCountryPhoneIndexWithData < ActiveRecord::Migration[5.2]
  def change
    CountryPhoneIndex.create!(iso_code: "DE", phone_index: "+49", length_limit: 11)
    CountryPhoneIndex.create!(iso_code: "GE", phone_index: "+995", length_limit: 9)
  end
end
