module Validations
  module UsernameValidation

    def valid_username_format?(username, option = {})
      return false if username.nil?

      username.match?(/^[a-zA-Z\d]*$/)
    end

    def valid_username_min_length?(username, option = {})
      return false if username.nil?

      username.length > 5
    end

    def valid_username_max_length?(username, option = {})
      return false if username.nil?

      username.length < 33
    end

    def self.valid_username_format?(username, option = {})
      return false if username.nil?

      username.match?(/^[a-zA-Z\d]*$/)
    end

    def self.valid_username_min_length?(username, option = {})
      return false if username.nil?

      username.length > 5
    end

    def self.valid_username_max_length?(username, option = {})
      return false if username.nil?

      username.length < 33
    end

  end
end