module Validations
  module PhoneNumberValidation
    def self.valid_phone_number_format?(phone_number, option = {})
      return false if phone_number.nil?
      phone_number.match?(/^[0-9]*$/)
    end

    def valid_phone_number_format?(phone_number, option = {})
      return false if phone_number.nil?
      phone_number.match?(/^[0-9]*$/)
    end

    def valid_phone_number_length?(phone_number, option = {})
      phone_number.length == 9
    end

    def self.valid_phone_number_length?(phone_number, option = {})
      phone_number.length == 9
    end
  end
end