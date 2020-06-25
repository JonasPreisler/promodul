module Account
  class RegistrationService
    require 'errors_format'
    include ErrorsFormat
    include Validations::ModelValidation

    attr_reader :token , :errors

    def initialize(registration_params = {})
      @registration_params = registration_params
      @errors = []
    end

    def sign_up_json_view
      { confirmation_token: @token } if @token
    end

    def call
      validate_agreements
      validate_phone_number
      validate_password_matching
      return if @errors.any?

      ActiveRecord::Base.transaction do
        register_user!
        create_terms_and_conditions
        generate_token
      end
    end

    private

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

    def validate_phone_number
      return if errors.any?
      service = Validations::PhoneNumberValidationService.new(self, @registration_params[:phone_number], @registration_params[:phone_number_iso])
      service.validate
      @country_index = service.country_index
    end

    def register_user!
      @user = UserAccount.new(@registration_params.slice(:first_name, :last_name, :birth_date, :phone_number, :phone_number_iso, :email, :password, :username))
      @user.save
      @errors.concat(fill_errors(@user))
    rescue ActiveRecord::RecordNotUnique
      fill_custom_errors(self,:username, :not_unique,  I18n.t('custom.errors.phone_number_duplicated')) if UserAccount.exists?(username: @registration_params[:username])
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

    def create_customer
      # create customer method
    end

    def create_supplier
      # create customer supplier
    end

    def create_employee
      # create customer employee
    end
  end
end