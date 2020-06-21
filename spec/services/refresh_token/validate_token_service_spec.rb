# DHP-50
RSpec.describe RefreshToken::ValidateTokenService do
  describe 'validates refresh token expired date' do
    before do
      @credentials = {
        username: Faker::Internet.user_name,
        password: Faker::Internet.password
      }

      @user = create(:user, username: @credentials[:username], password: @credentials[:password])
    end

    it 'valid if  expired date is more then current time' do
      stub_const("JWT_TOKEN_EXPIRED_MIN", 0)
      auth = Auth::Service.new.auth_current_user!(@credentials)

      sleep(1)

      result = RefreshToken::ValidateTokenService.new(auth.content.dig(:data, :refresh_token)).call
      expect(result.valid?).to eq(true)
    end

    it 'invalid if  expired date is less then current time' do
      stub_const("JWT_TOKEN_EXPIRED_MIN", 0)
      stub_const("REFRESH_TOKEN_EXPIRED_MIN", 0)

      auth = Auth::Service.new.auth_current_user!(@credentials)

      sleep(1)

      result = RefreshToken::ValidateTokenService.new(auth.content.dig(:data, :refresh_token)).call
      expect(result.valid?).to eq(false)
    end
  end
end
