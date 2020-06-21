# DHP-50
RSpec.describe Jwt::TokenDecoderService do
  describe 'Decode JWT token' do
    describe 'Hmac token provider' do
      before do
        @payload = { data: 'test' }
      end

      it 'returns token' do
        hmac_provider = Jwt::Providers::Hmac.new
        hmac_provider.algorithm = 'HS256'
        hmac_provider.secret_key = 'secter'

        token = Jwt::TokenProviderService.new(@payload, hmac_provider).call

        decoded_token = Jwt::TokenDecoderService.new(token, hmac_provider).call

        expect(decoded_token).not_to be_empty
      end

      it 'decodes token' do
        hmac_provider = Jwt::Providers::Hmac.new
        hmac_provider.algorithm = 'HS512'
        hmac_provider.secret_key = 'secter'

        payload = { data: { name: Faker::Name.name } }
        token = Jwt::TokenProviderService.new(payload, hmac_provider).call

        decoded_token = Jwt::TokenDecoderService.new(token, hmac_provider).call

        decoded_data = decoded_token[0].deep_symbolize_keys

        expect(decoded_data.dig(:data, :name)).to eq(payload[:data][:name])
      end

      it 'does not decodes token if secter is wrong' do
        hmac_provider = Jwt::Providers::Hmac.new
        hmac_provider.algorithm = 'HS512'
        hmac_provider.secret_key = 'secter'

        payload = { data: { name: Faker::Name.name } }
        token = Jwt::TokenProviderService.new(payload, hmac_provider).call

        hmac_provider.secret_key = 'new_secret'

        expect { Jwt::TokenDecoderService.new(token, hmac_provider).call }.to raise_error(JWT::VerificationError)
      end

      it 'raises error because of expiration time' do
        hmac_provider = Jwt::Providers::Hmac.new
        hmac_provider.algorithm = 'HS512'
        hmac_provider.secret_key = 'secter'

        expiration_time = Time.now.to_i + 1.seconds

        payload = { data: { name: Faker::Name.name }, exp: expiration_time }
        token = Jwt::TokenProviderService.new(payload, hmac_provider).call

        sleep(2)

        expect { Jwt::TokenDecoderService.new(token, hmac_provider).call }.to raise_error(JWT::ExpiredSignature)
      end

      it 'decodes token with options' do
        iss = Faker::Company.name
        hmac_provider = Jwt::Providers::Hmac.new
        hmac_provider.algorithm = 'HS512'
        hmac_provider.secret_key = 'secter'
        hmac_provider.options = { iss: iss, verify_iss: true }

        payload = { data: { name: Faker::Name.name }, iss: iss }
        token = Jwt::TokenProviderService.new(payload, hmac_provider).call

        decoded_token = Jwt::TokenDecoderService.new(token, hmac_provider).call

        decoded_data = decoded_token[0].deep_symbolize_keys

        expect(decoded_data.dig(:data, :name)).to eq(payload[:data][:name])
      end
    end

    describe 'None token provider' do
      before do
        @payload = { data: 'test' }
      end

      it 'returns token' do
        none_provider = Jwt::Providers::None.new

        token = Jwt::TokenProviderService.new(@payload, none_provider).call

        decoded_token = Jwt::TokenDecoderService.new(token, none_provider).call

        expect(decoded_token).not_to be_empty
      end

      it 'decodes token' do
        none_provider = Jwt::Providers::None.new

        payload = { data: { name: Faker::Name.name } }
        token = Jwt::TokenProviderService.new(payload, none_provider).call

        decoded_token = Jwt::TokenDecoderService.new(token, none_provider).call

        decoded_data = decoded_token[0].deep_symbolize_keys

        expect(decoded_data.dig(:data, :name)).to eq(payload[:data][:name])
      end
    end
  end
end
