module Integrations
  class TwilioRequestService
    require 'rubygems'
    require 'twilio-ruby'

    def initialize(country_code, phone_number, code = nil)
      @country_code = country_code
      @phone_number = phone_number
      @code = code
      @client = Twilio::REST::Client.new(Figaro.env.TWILIO_ACCOUNT_SID, Figaro.env.TWILIO_AUTH_TOKEN  )
    end

    def start_verification(country_code, phone_number)
      begin
        verification = @client.verify
                           .services(Figaro.env.TWILIO_SERVICE_SID)
                           .verifications
                           .create(locale: 'nb', to: "+#{country_code}#{phone_number}", channel: 'sms')

        verification
      rescue Twilio::REST::RestError => e
        Rails.logger.error "SMS Sending Error - #{e} - Confirmation Code, number: #{phone_number}"
      end
    end

    def verify_code(country_code, phone_number, code)
      begin
        verification_check = @client.verify
                                 .services(Figaro.env.TWILIO_SERVICE_SID)
                                 .verification_checks
                                 .create(to: "+#{+country_code}#{phone_number}", code: code)

        if verification_check.status == 'approved'
          current_account.update_column(:phone_verified, true)
        end
      rescue Twilio::REST::RestError => e
        show_error(e)
      end
    end
  end
end