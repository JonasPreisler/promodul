module Account
  class RegistrationService
    require 'errors_format'
    include ErrorsFormat
    include Validations::ModelValidation

    attr_reader :token , :errors

    def initialize(current_company, registration_params = {}, user_id = nil )
      @current_company = current_company
      @registration_params = registration_params
      @errors = []
    end

    def sign_up_json_view
      { success: true }
    end

    def customer_types_json_view
      { customer_types: @customer_types }
    end

    def create_customer_json_view
      { customer: @customer }
    end

    def call
      validate_username
      validate_password_matching
      return if @errors.any?
      ActiveRecord::Base.transaction do
        register_user!
        create_customer!
        add_default_role!
        generate_token
        finish_registration
      end
    end

    def add_default_role!
      UserRole.create(user_account_id: @user.id, role_group_id: RoleGroup.find_by_id_name("employee").id)
    end

    def finish_registration
      verification_service = Account::VerificationService.new({ user: nil, token: @token })
      @verification = verification_service.verification
      validate_token(verification_service)
      validate_generation_time(verification_service)
      validate_attempts(verification_service)
      update_attempts_count
      return if errors.any?
      ActiveRecord::Base.transaction do
        set_active!(verification_service)
        delete_registration_codes!(verification_service)
      end
    end

    def authorization_token
      "Bearer #{ @auth_token }"
    end

    def delete_registration_codes!(verification_service)
      verification_service.verification.destroy
    end

    def set_active!(verification_service)
      user = verification_service.verification.user_account
      user.active = true
      user.save!
    end

    def update_attempts_count
      return if errors.any? || @verification.nil?
      @verification.failed_attempts_count  = 1
      @verification.save
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

    def cancel(token)
      code = ConfirmationCode.find_by(confirmation_token: token)
      code.user_account.destroy
    rescue
      fill_custom_errors(self,:confirmation_token, :invalid, I18n.t('custom.errors.invalid_token'))
    end

    def create_business_customer
      validate_customer_type
      find_and_validate_user
      create_customer!
    end

    def customer_types
      @customer_types = CustomerType.all
    end

    def json_view
      { confirmation_token: @token } if @token
    end

    private

    def validate_customer_type
      id_name = CustomerType.find_by_id_name(:multi_business_customer).id_name
      validation = @registration_params[:customer_type].eql?(id_name)
      fill_custom_errors(self, :base, :invalid, I18n.t("custom.errors.validation.business_customer")) unless validation
    end

    def find_and_validate_user
      @user = UserAccount.find(@registration_params[:user_account_id].to_i)
      fill_custom_errors(self, :base, :invalid, I18n.t("custom.errors.validation.user_not_found")) unless @user
    end

    def validate_agreements
      return if @errors.any?
      last_terms_and_conditions_id = TermsAndCondition.order("active_from DESC").first.id
      valid_terms = @registration_params[:terms_and_conditions_id].eql?(last_terms_and_conditions_id)
      agreed = @registration_params[:agreed_terms_and_conditions]
      unless valid_terms &&  agreed
        fill_custom_errors(self,:base, :invalid, I18n.t("custom.errors.user_agreement"))
      end
    end

    def validate_password_matching
      passwords_match = @registration_params[:password] == @registration_params[:password_confirmation]
      fill_custom_errors(self, :password, :confirmation,  I18n.t('custom.errors.password_confirmation')) unless passwords_match
    end

    def validate_username
      if UserAccount.where(username: @registration_params[:username], company_id: @current_company.id).any?
        fill_custom_errors(self, :username, :confirmation,  "username already exists, please choose another username")
      end
    end

    def validate_phone_number
      return if errors.any?
      service = Validations::PhoneNumberValidationService.new(self, @registration_params[:phone_number], @registration_params[:phone_number_iso])
      service.validate
      @country_index = service.country_index
    end

    def register_user!
      @user = UserAccount.new(@registration_params.slice(:phone_number, :phone_number_iso, :email, :password, :username, :first_name, :last_name))
      @user.company_id = @current_company.id
      @user.save
      @errors.concat(fill_errors(@user))
    rescue ActiveRecord::RecordNotUnique
      fill_custom_errors(self,:username, :not_unique,  I18n.t('custom.errors.phone_number_duplicated')) if UserAccount.exists?(username: @registration_params[:username])
    end

    def create_customer!
      return if @errors.any?
      @customer = Customer.create!(customer_object)
      @errors.concat(fill_errors(@customer))
    end

    def create_terms_and_conditions
      return if @errors.any?
      TermsAndConditionAgreement.create!(user_account_id: @user.id,
                                         terms_and_condition_id: @registration_params[:terms_and_conditions_id],
                                         agreed_date: DateTime.now)
    rescue Exception => ex
      fill_custom_errors(self,:base, :invalid, ex.message)
    end

    def generate_token
      return if errors.any?
      @token = Account::ConfirmationService.new({user: @user, confirmation_type: 'registration'}).send_confirmation
    end

    def customer_object
      @registration_params.
          slice(:name,
                :delivery_address,
                :invoice_address,
                :legal_id).
          merge(user_account_id: @user.id,
                active: true)
    end
  end
end