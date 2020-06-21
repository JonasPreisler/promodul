# DHP-50
RSpec.describe RefreshToken::GenerateTokenService do
  describe 'Generates uniq token' do
    it 'returns token' do
      token = RefreshToken::GenerateTokenService.new.call

      expect(token).not_to be_empty
    end

    it 'returns uniq token' do
      token1 = RefreshToken::GenerateTokenService.new.call
      token2 = RefreshToken::GenerateTokenService.new.call

      expect(token1).not_to eq(token2)
    end
  end
end
