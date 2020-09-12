module Jwt
  class ValidateTokenService
    attr_reader :jwt_token

    def initialize(jwt_token)
      @jwt_token = jwt_token
      @valid = false
    end

    def call
      data = decode_token[0]
      OpenStruct.new(valid?:  $redis.get("access_#{data["user_id"]}:#{data["jti"]}").present?)
    rescue
      OpenStruct.new(valid?: false)
    end

    private
    def decode_token
      JWT.decode(jwt_token, secret_key, true, { algorithm: algorithm }.merge(options) )
    end

    def algorithm
      'HS256'
    end

    def options
      {}
    end

    def secret_key
      Rails.application.credentials.jwt_secret_key
    end
  end
end
