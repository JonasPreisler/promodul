module Account
  class RegistrationController < ApplicationController
    require 'controller_response'
    include ControllerResponse
    skip_before_action :validate_authentication

    #UserAccount registration
    def sign_up
      registration = Account::RegistrationService.new(user_account_params)
      registration.call
      rest_respond_service registration
    end


    private

    def user_account_params
      params.permit(:first_name,
                    :last_name,
                    :username,
                    :birth_date,
                    :phone_number,
                    :email,
                    :password,
                    :password_confirmation)
    end

  end
end

