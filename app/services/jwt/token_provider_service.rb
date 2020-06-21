# DHP-50
module Jwt
  class TokenProviderService
    attr_reader :payload, :provider

    def initialize(payload, provider)
      @payload = payload
      @provider = provider
    end

    def call
      provider.provide_token(payload)
    end
  end
end
