module Account
  class RegistrationService
    require 'errors_format'
    include ErrorsFormat
    include Validations::ModelValidation

    attr_reader :token , :errors

    def initialize(registration_params = {}, user_id = nil )
      @registration_params = registration_params
      @errors = []
    end

    def sign_up_json_view
      { confirmation_token: @token } if @token
    end

    def customer_types_json_view
      { customer_types: @customer_types }
    end

    def create_customer_json_view
      { customer: @customer }
    end

    def call
      binding.pry
      validate_agreements
      validate_phone_number
      validate_password_matching
      return if @errors.any?

      ActiveRecord::Base.transaction do
        binding.pry

        register_user!
        create_customer!
        create_terms_and_conditions
        generate_token
      end
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
      binding.pry
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
      @user = UserAccount.new(@registration_params.slice(:phone_number, :phone_number_iso, :email, :password, :username))
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
                customer_type_id: CustomerType.find_by_id_name(@registration_params[:customer_type].to_sym).id,
                active: true)
    end
  end
end