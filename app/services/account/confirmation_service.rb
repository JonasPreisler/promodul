module Account
  class ConfirmationService
      include ErrorsFormat

      attr_reader :user, :token, :verification, :errors, :sms_code

      def initialize(confirmation_params)
        @device_token = confirmation_params[:device_token]
        @user = confirmation_params[:user]
        @confirmation_type = confirmation_params[:confirmation_type]
        @token = confirmation_params[:token]
        @sms_code = confirmation_params[:sms_code]
        @errors = []
      end

      def finish_registration
        verification_service = Account::VerificationService.new({ user: user, token: token })
        @verification = verification_service.verification
        validate_token(verification_service)
        validate_generation_time(verification_service)
        validate_attempts(verification_service)
        #validate_sms_code(verification_service)
        update_attempts_count
        return if errors.any?
        ActiveRecord::Base.transaction do
          #Changed user confirmatio flow, now user should be confirmed by admin!
          #set_active!(verification_service)
          delete_registration_codes!(verification_service)
        end
      end

      def send_confirmation
        @verification = Account::VerificationService.new({ user: @user, confirmation_type: @confirmation_type }).generate_codes
        @verification.confirmation_token
      end

      def regenerate_sms
        verification_service = Account::VerificationService.new({ user: user, token: token })

        validate_token(verification_service)
        validate_generation_time(verification_service)
        validate_retry_count(verification_service)

        return if errors.any?
        @verification = verification_service.regenerate_for_sms
        @phone_number = @verification.user_account.phone_number
        send_sms
      end

      def check_sms_code
        verification_service = Umg::Account::VerificationService.new({ token: @token })
        @verification = verification_service.verification
        validate_token(verification_service)
        validate_generation_time(verification_service)
        check_first_code(verification_service)
      end

      def store_auth_token!
        @auth_token = SecureRandom.hex
        user_id = @verification.user_account_id

        storage = TokenStorage::AutoLoginTokenService.new
        storage.store_auth_token(@auth_token, user_id)
      end

      def store_inactive_user!
        user = @verification.user_account
        storage = Account::ConfirmationStorageService.new
        storage.store_user_in_redis(user, true)
      end

      def authorization_token
        "Bearer #{ @auth_token }"
      end

      def confirm_registration_json_view
        {}
      end

      def send_sms
        iso_code = @verification.user_account.phone_number_iso.to_s.upcase
        phone_number_index = CountryPhoneIndex.find_by(iso_code: iso_code)&.phone_index
        Integrations::TwilioRequestService.new(phone_number_index, @verification.user_account.phone_number, nil ).start_verification
      end

      private

      def validate_generation_time(verification_service)
        return if errors.any?
        validation = verification_service.valid_generation_time?
        fill_custom_errors(self, :generation_time,:invalid_time, I18n.t("custom.errors.registration_invalid_time")) unless validation
      end

      def validate_retry_count(service)
        return if errors.any?
        validation = service.valid_retry_count?
        fill_custom_errors(self, :sms_code, :invalid_retry_count, I18n.t("custom.errors.registration_retry_count")) unless validation
      end

      def sms_text(code)
        "#{I18n.t('sms.confirmation_code')} - #{code}"
      end

      def set_active!(verification_service)
        user = verification_service.verification.user_account
        user.active = true
        user.save!
      end

      def check_first_code(service)
        return if errors.any?
        valid = service.valid_sms_code?(@sms_code)
        fill_custom_errors(self, :sms_code, :invalid, I18n.t("custom.errors.sms_code")) unless valid
      end

      def delete_registration_codes!(verification_service)
        verification_service.verification.destroy
      end

      def validate_token(verification_service)
        return if errors.any?
        code = ConfirmationCode.find_by_confirmation_token(verification_service.verification&.confirmation_token)
        fill_custom_errors(self, :confirmation_token, :invalid, I18n.t("custom.errors.invalid_token")) unless code
      end

      def validate_attempts(verification_service)
        return if errors.any?
        valid_try = verification_service.valid_single_code_retry?
        fill_custom_errors(self, :sms_code, :invalid_retry_count, I18n.t("custom.errors.registration_attempts_count")) unless valid_try
      end

      def validate_sms_code(verification_service)
        return if errors.any?
        iso_code = @verification.user_account.phone_number_iso.to_s.upcase
        phone_number_index = CountryPhoneIndex.find_by(iso_code: iso_code)&.phone_index
        validation = Integrations::TwilioRequestService.new(phone_number_index, @verification.user_account.phone_number, sms_code ).verify_code

        fill_custom_errors(self, :sms_code, :invalid, I18n.t("custom.errors.sms_code")) unless validation.eql?("approved")
      end

      def update_attempts_count
        return if errors.any? || @verification.nil?
        @verification.failed_attempts_count  = 1
        @verification.save
      end
    end
end

