module Validations
  module EmailValidation

    def self.valid_email_format?(email, option = {})
      return false if email.nil? || email.length > 255
      email.match?(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)
    end

    def valid_email_format?(email, option = {})
      return false if email.nil? || email.length > 255
      email.match?(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)
    end
  end
end