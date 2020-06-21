# DHP-50
RSpec.describe Jwt::TokenProviderService do
  describe 'Provide JWT token' do
    describe 'Hmac token provider' do
      before do
        @payload = { data: 'test' }
        @hmac_provider = Jwt::Providers::Hmac.new
      end

      it 'returns token' do
        token = Jwt::TokenProviderService.new(@payload, @hmac_provider).call

        expect(token).not_to be_empty
      end

      it 'returns valid payload data' do
        token = Jwt::TokenProviderService.new(@payload, @hmac_provider).call

        _, payload_base64, _ = token.split('.')

        payload_data = Base64.decode64(payload_base64)
        payload_data = JSON.parse(payload_data).symbolize_keys

        expect(payload_data).to eq(@payload)
      end

      it 'returns valid algorithm' do
        @hmac_provider.secret_key = 'secret'
        @hmac_provider.algorithm = 'HS512'

        token = Jwt::TokenProviderService.new(@payload, @hmac_provider).call

        header_base64, _, _ = token.split('.')

        header = Base64.decode64(header_base64)
        header = JSON.parse(header).symbolize_keys

        expect(header[:alg]).to eq('HS512')
      end
    end

    describe 'None token provider' do
      before do
        @payload = { data: 'test' }
        @none_provider = Jwt::Providers::None.new
      end

      it 'returns token' do
        token = Jwt::TokenProviderService.new(@payload, @none_provider).call

        expect(token).not_to be_empty
      end

      it 'returns valid payload data' do
        token = Jwt::TokenProviderService.new(@payload, @none_provider).call

        _, payload_base64, _ = token.split('.')

        payload_data = Base64.decode64(payload_base64)
        payload_data = JSON.parse(payload_data).symbolize_keys

        expect(payload_data).to eq(@payload)
      end

      it 'returns valid algorithm' do
        token = Jwt::TokenProviderService.new(@payload, @none_provider).call

        header_base64, _, _ = token.split('.')

        header = Base64.decode64(header_base64)
        header = JSON.parse(header).symbolize_keys

        expect(header[:alg]).to eq('none')
      end
    end
  end
end
