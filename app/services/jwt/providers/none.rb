module Jwt
  module Providers
    class None < Token
      def secret_key
        nil
      end

      def algorithm
        'none'
      end

      def provide_token(payload)
        encode(payload)
      end

      def decode_token(token)
        decode(token)
      end

      private

        def encode(payload)
          JWT.encode(payload, secret_key, algorithm, { typ: 'JWT' })
        end

        def decode(token)
          JWT.decode(token, secret_key, false)
        end
    end
  end
end
