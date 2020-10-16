module Auth
  class Service
    include PgSqlHelper

    attr_reader :client_headers, :bearer_token, :errors, :status_code

    def initialize(client_headers = {})
      @client_headers = client_headers
      @bearer_token = client_headers[:bearer_token]
      @errors = []
    end

    def check_params(auth_params)
      @errors << { message: I18n.t('errors.auth.wrong_username'), field: :username, code: 4 } unless auth_params[:username]
      @errors << { message: I18n.t('errors.auth.wrong_password'), field: :password, code: 4 } unless auth_params[:password]
      @errors
    end

    def auth_current_user!(auth_params)
      user = find_and_authenticate_user(auth_params)
      if user
        refresh_token, jwt_token = generate_tokens(user.id)
        General::RespondResultService.new.call(
            success?: true,
            data: { token: jwt_token, refresh_token: refresh_token },
            status_code: :ok
        )
      else
        General::RespondResultService.new.call(
            success?: false,
            errors: errors,
            status_code: (@status_code || :unauthorized)
        )
      end

    rescue => e
      Rails.logger.error("Method: #{ __method__ }, Error: #{ e }")
      General::RespondResultService.new.call(
          success?: false,
          errors: [ {message: I18n.t('errors.internal_server_error'), field: :base, code: 1} ], #TODO
          status_code: :internal_server_error
      )

    end

    def refresh_token!
      result = RefreshToken::ValidateTokenService.new(bearer_token).call

      if result.valid? && result.user_id.present?
        new_refresh_token = RefreshToken::GenerateTokenService.new.call

        storage = TokenStorage::RefreshTokenService.new(result.user_id, client_headers)
        payload = generate_payload(storage)
        storage.store_refresh_token(new_refresh_token, payload[:jti])
        storage.refresh_token(bearer_token)
        jti_service = TokenStorage::JtiService.new(result.user_id)
        jti_service.store_jti_token(payload[:jti])

        jwt_token = Jwt::TokenProviderService.new(payload, Jwt::Providers::Hmac.new).call

        General::RespondResultService.new.call(
            success?: true,
            data: { token: jwt_token, refresh_token: new_refresh_token },
            status_code: :ok
        )
      else
        General::RespondResultService.new.call(
            success?: false,
            errors: [ {message: I18n.t('errors.unauthorized'), field: :base, code: 2} ],
            status_code: :unauthorized
        )
      end
    rescue => e
      Rails.logger.error("Method: #{ __method__ }, Error: #{ e }")
      General::RespondResultService.new.call(
          success?: false,
          errors: [ {message: I18n.t('errors.internal_server_error'), field: :base, code: 1} ],
          status_code: :internal_server_error
      )
    end

    def destroy_token!
      result = RefreshToken::ValidateTokenService.new(bearer_token).call

      if result.valid? && result.user_id.present?

        TokenStorage::RefreshTokenService.new(result.user_id, client_headers).delete_refresh_token(bearer_token)
        TokenStorage::JtiService.new(result.user_id).delete_jti_token(result[:jti])

        General::RespondResultService.new.call(
            success?: true,
            data: nil,
            status_code: :ok
        )
      else
        General::RespondResultService.new.call(
            success?: false,
            errors: [ {message: I18n.t('errors.unauthorized'), field: :base, code: 2} ],
            status_code: :unauthorized
        )
      end

    rescue => e
      Rails.logger.error("Method: #{ __method__ }, Error: #{ e }")
      General::RespondResultService.new.call(
          success?: false,
          errors: [ {message: I18n.t('errors.internal_server_error'), field: :base, code: 1}  ],
          status_code: :internal_server_error
      )
    end


    private
    def generate_payload(storage)
      {
          expired_at: storage.expired_at_time.to_i,
          user_id: storage.user_id,
          exp: (storage.current_time + JWT_TOKEN_EXPIRED_MIN.minutes).to_i,
          jti: SecureRandom.hex
      }
    end

    def find_and_authenticate_user(auth_params)
      if bearer_token.present?
        find_user_with_token(bearer_token)
      else
        find_user_with_credentials(auth_params)
      end
    end

    def find_user_with_token(token)

      storage = TokenStorage::AutoLoginTokenService.new
      auth_token_data = storage.find_auth_token(token)

      if auth_token_data.present?
        token_expired_at = DateTime.parse(auth_token_data['expired_at'])

        if token_expired_at > DateTime.now
          user = UserAccount.find_by(id: auth_token_data['user_id'], active: true, locked: false)

          errors << { message: I18n.t('errors.unauthorized'), field: :base, code: 2} if user.blank?

          user
        end
      else
        errors << { message: I18n.t('errors.unauthorized'), field: :base, code: 2}
        nil
      end
    rescue
      nil
    ensure
      storage.delete_auth_token(token)
    end

    def find_user_with_credentials(auth_params)
      user = UserAccount.authenticate(auth_params[:username].to_s.downcase, auth_params[:password])
      #user = UserAccount.where(username: "bukabuka").first
      lock_service = Auth::LockingManagementService.new(user, auth_params[:username].to_s.downcase)
      check_locking(lock_service)
      errors.any? ? nil : user
    end

    def check_user(user)
      errors << {message: I18n.t('errors.unauthorized'), field: :base, code: 2} unless user.active
    end

    def check_locking(lock_service)
      error_msg = lock_service.invalid_user_error_message
      @status_code = lock_service.status_code if error_msg.present?
      errors << {message: error_msg, field: :base, code: 2} if error_msg.present?
    end

    def generate_tokens(user_id)
      refresh_token = RefreshToken::GenerateTokenService.new.call

      storage = TokenStorage::RefreshTokenService.new(user_id, client_headers)
      payload = generate_payload(storage)
      storage.store_refresh_token(refresh_token, payload[:jti])
      jti_service = TokenStorage::JtiService.new(user_id)
      jti_service.store_jti_token(payload[:jti])

      jwt_token = Jwt::TokenProviderService.new(payload, Jwt::Providers::Hmac.new).call
      return refresh_token, jwt_token
    end

  end
end

