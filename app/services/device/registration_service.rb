module Device
  class RegistrationService

    def initialize(user, auth_param)
      @user = user
      @device_token = auth_param[:device_token]
      @language = I18n.locale
    end

    def call
      return unless @device_token
      device = DeviceUser.find_or_initialize_by(device_token: @device_token)
      device.update(umg_user_account_id: @user.id, language: @language)
      DeviceUser.where(umg_user_account_id: @user.id).where.not(id: device.id).destroy_all
    end
  end
end

