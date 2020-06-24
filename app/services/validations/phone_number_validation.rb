module Validations
  module PhoneNumberValidation
    def valid_phone_number_format?(phone_number)
      return false if phone_number.nil?
      phone_number.match?(/^[0-9]*$/)
    end

    def valid_phone_number_length?(phone_number, option = {})
      length = Umg::CountryPhoneIndex.find_by(iso_code: option[:phone_number_iso]).length_limit
      if length.present?
        phone_number.to_s.length == length
      else
        phone_number.to_s.length < 20
      end
    end
  end
end