module Account
  class VerificationService
    attr_accessor :user, :token, :verification, :confirmation_type

    def initialize(params)
      @user = params[:user]
      @token = params[:token]

      @confirmation_type = params[:confirmation_type] || 'registration'

      @verification = ConfirmationCode.find_by_confirmation_token(token) if token
    end

    def generate_codes
      type_record = ConfirmationType.find_by_id_name(@confirmation_type)
      @verification = ConfirmationCode.where(user_account_id: @user.id, confirmation_type: type_record).first_or_initialize
      create_new_token
      #set_sms_status
      set_time_and_save
    end

    def regenerate_for_sms
      set_sms_status
      increment_retry
      set_time_and_save
    end

    def valid_sms_code?(sms)
      valid_token? && sms == @verification.sms_code
    end

    def valid_token?
      valid_generation_time? && valid_retry_count?
    end

    def valid_generation_time?
      !@verification.nil? && @verification.generation_time + CONFIRMATION_CODES_LIFE_TIME.minutes > Time.now
    end

    def valid_retry_count?
      !@verification.nil? && @verification.retry_count.to_i < MAX_REGENERATION_COUNT
    end

    def valid_single_code_retry?
      @verification.present? && @verification.failed_attempts_count < SINGLE_CODE_RETRY_COUNT
    end

    private

    def set_sms_status
      @verification.sms_code = 'pending'
      @verification.failed_attempts_count = 0
    end

    def set_time_and_save
      @verification.generation_time = DateTime.now
      @verification.save!
      @verification
    end

    def increment_retry
      @verification.retry_count.nil? ?  @verification.retry_count = 1 : @verification.retry_count +=1
     end

    def create_new_token
      unless @verification.new_record?
        @verification.regenerate_confirmation_token
        @verification.retry_count = 0
      end
    end

  end
end