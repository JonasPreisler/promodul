module RefreshToken
  class GenerateTokenService
    def call
      generate_uuid
    end

    private
      def generate_uuid
        SecureRandom.uuid
      end
  end
end
