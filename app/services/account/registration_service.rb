module Account
  class RegistrationService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :token , :errors

    def initialize(registration_params = {})
      @registration_params = registration_params
      @errors = []
    end

    def sign_up_json_view
      { success: true }
    end

    def call
      return unless passwords_match?

      @user = UserAccount.new(@registration_params.slice(:first_name, :last_name, :birth_date, :phone_number, :email, :password, :username))
      @user.save
      @errors.concat(fill_errors(@user))
    rescue ActiveRecord::RecordNotUnique
      fill_custom_errors(self,:username, :not_unique,  I18n.t('custom.errors.phone_number_duplicated')) if UserAccount.exists?(username: @registration_params[:username])
    end

    private

    def passwords_match?
      unless @registration_params[:password] == @registration_params[:password_confirmation]
        fill_custom_errors(self, :password, :confirmation,  I18n.t('custom.errors.password_confirmation'))
        return false
      end
      true
    end

  end
end