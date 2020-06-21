# DHP-50
module RefreshToken
  class ValidateTokenService
    attr_accessor :resfresh_token

    attr_reader :valid, :user_id, :old_token

    def initialize(resfresh_token)
      @resfresh_token = resfresh_token
    end

    def call
      token_data = TokenStorage::RefreshTokenService.new(nil, {}).find_refresh_token(resfresh_token)

      OpenStruct.new(valid?: valid_expired_date?(token_data), user_id: token_data['user_id'], old_token: resfresh_token, jti: token_data["jti"])
    rescue => e
      OpenStruct.new(valid?: false, user_id: nil).tap do |_|
        Rails.logger.error("Method: #{ __method__ }, Error: #{ e }")
      end
    end

    private
    def valid_expired_date?(token_data)
      token_data.any? && token_data['expired_at'].to_datetime > Time.now.to_datetime
    end
  end
end