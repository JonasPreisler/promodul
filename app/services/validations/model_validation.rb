module Validations
  module ModelValidation
    extend ActiveSupport::Concern
    include Validations::PasswordValidation
    include Validations::DateValidation
    include Validations::EmailValidation
    include Validations::PhoneNumberValidation
    include Validations::UniquenessValidation
    include Validations::UsernameValidation

    module ClassMethods
      def options(method_name, column, option = {})
        option[:column] = column
        Proc.new do
          unless send(method_name, self.send(column), option)
            self.errors.add(column, :invalid, message: I18n.t("custom.errors.validation.#{method_name}"))
          end
        end
      end
    end
  end
end