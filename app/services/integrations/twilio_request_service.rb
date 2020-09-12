module Integrations
  class TwilioRequestService
    require 'rubygems'
    require 'twilio-ruby'

    def initialize(country_code, phone_number, code = nil)
      @country_code = country_code
      @phone_number = phone_number
      @code = code
      #binding.pry
      #@client = Twilio::REST::Client.new(Figaro.env.TWILIO_ACCOUNT_SID, Figaro.env.TWILIO_AUTH_TOKEN  )
    end

    def start_verification
      @client = Twilio::REST::Client.new(Figaro.env.TWILIO_ACCOUNT_SID, Figaro.env.TWILIO_AUTH_TOKEN  )
      begin
         @client.verify.services(Figaro.env.TWILIO_SERVICE_SID).verifications.create(locale: 'nb', to: "+#{@country_code}#{@phone_number}", channel: 'sms')
      rescue Twilio::REST::RestError => e
        Rails.logger.error "SMS Sending Error - #{e} - Confirmation Code, number: #{@phone_number}"
      end
    end

    def verify_code
      @client = Twilio::REST::Client.new(Figaro.env.TWILIO_ACCOUNT_SID, Figaro.env.TWILIO_AUTH_TOKEN  )
      begin
        verification_check = @client.verify
                                 .services(Figaro.env.TWILIO_SERVICE_SID)
                                 .verification_checks
                                 .create(to: "+#{+@country_code}#{@phone_number}", code: @code)
        verification_check.status
      rescue Twilio::REST::RestError => e
        #ToDo: add fill error service
        show_error(e)
      end
    end
  end
end