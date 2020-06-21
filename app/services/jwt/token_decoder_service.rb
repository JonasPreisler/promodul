module Jwt
  class TokenDecoderService
    attr_reader :token, :provider

    def initialize(token, provider)
      @token = token
      @provider = provider
    end

    def call
      provider.decode_token(token)
    end
  end
end
