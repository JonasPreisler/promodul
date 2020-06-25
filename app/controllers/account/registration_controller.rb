module Account
  class RegistrationController < ApplicationController
    require 'controller_response'
    include ControllerResponse
    skip_before_action :validate_authentication

    #UserAccount registration Step-1
    def sign_up
      registration = Account::RegistrationService.new(user_account_params)
      registration.call
      rest_respond_service registration
    end

    #Confirm user registration Step-2
    def confirm_registration
      confirmation = Account::ConfirmationService.new(confirmation_params)
      confirmation.finish_registration

      unless confirmation.errors.any?
        confirmation.store_auth_token!
        response.headers["Authorization"] = confirmation.authorization_token
      end

      rest_respond_service confirmation
    end


    private

    def user_account_params
      params.permit(:first_name,
                    :last_name,
                    :username,
                    :birth_date,
                    :phone_number,
                    :phone_number_iso,
                    :email,
                    :password,
                    :password_confirmation,
                    :agreed_terms_and_conditions,
                    :terms_and_conditions_id)
    end

    def confirmation_params
      params.permit(:token, :sms_code)
    end

  end
end
