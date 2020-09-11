module Account
  class RegistrationController < ApplicationController
    require 'controller_response'
    include ControllerResponse
    skip_before_action :validate_authentication

    #UserAccount registration Step-1
    def sign_up
      binding.pry
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

    #Resend sms code
    def sms_code
      confirmation = Account::ConfirmationService.new(confirmation_params)
      confirmation.regenerate_sms
      rest_respond_service confirmation
    end

    #Cencel registration/Delete account
    def cancel_registration
      registration = Account::RegistrationService.new
      registration.cancel(params[:token])
      rest_respond_service registration
    end

    #Get Customer types for registration
    def customer_types
      service = Account::RegistrationService.new
      service.customer_types
      rest_respond_service service
    end

    #Create Only Customer on existing UserAccount
    def create_customer
      registration = Account::RegistrationService.new(customer_params)
      registration.create_business_customer
      rest_respond_service registration
    end


    private

    def user_account_params
      params.permit(  :phone_number,
                      :phone_number_iso,
                      :email,
                      :password,
                      :password_confirmation,
                      :agreed_terms_and_conditions,
                      :terms_and_conditions_id,
                      :name,
                      :username,
                      :delivery_address,
                      :invoice_address,
                      :customer_type)
    end

    def customer_params
      params.permit(  :email,
                      :name,
                      :delivery_address,
                      :invoice_address,
                      :user_account_id,
                      :customer_type
                      )
    end


    def confirmation_params
      params.permit(:token, :sms_code)
    end

  end
end

