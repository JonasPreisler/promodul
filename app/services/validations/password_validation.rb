module Validations
  module PasswordValidation
    def valid_password_format?(password, option = {})
      return true unless password
      return false if password && password.length < 8
      return false unless password.match?(/^[a-zA-Z\d, !, ", #, $, %, &, \', (, ), *, +, \,, \-, \., \/, :, ;, <, =, >, ?, @, \[, \\, \], ^, _, `, {, |, }, ~]+$/)
      count = 0

      count += 1 if password =~ /\d/
      count += 1 if password =~ /[a-z]/
      count += 1 if password =~ /[A-Z]/
      count += 1 if password =~ /[ , !, ", #, $, %, &, \', (, ), *, +, \,, \-, \., \/, :, ;, <, =, >, ?, @, \[, \\, \], ^, _, `, {, |, }, ~]/

      count >= 3
    end
  end
end