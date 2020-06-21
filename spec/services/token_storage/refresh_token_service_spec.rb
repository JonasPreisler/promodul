# DHP-50
RSpec.describe TokenStorage::RefreshTokenService do
  before do
    @user_id = Faker::Number.number(3)
    @storage = TokenStorage::RefreshTokenService.new(@user_id, {})
  end

  it 'stores token in Redis' do
    token = RefreshToken::GenerateTokenService.new.call

    @storage.store_refresh_token(token)

    stored_user_id = $redis.hget(token, "user_id")

    expect(stored_user_id).to eq(@user_id)
  end
end
