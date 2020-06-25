module TokenStorage
  class AutoLoginTokenService
    attr_reader :current_time

    def initialize
      @current_time = Time.now
      @prefix = "autologin_"
    end

    def store_auth_token(token, user_id)
      $redis.mapped_hmset(@prefix + token, { expired_at: expired_at_time, user_id: user_id })
      $redis.expire(@prefix + token, AUTO_AUTH_TOKEN_EXPIRED_MIN*60)
    end

    def find_auth_token(token)
      $redis.hgetall(@prefix + token)
    end

    def delete_auth_token(token)
      $redis.del(@prefix + token)
    end

    private

      def expired_at_time
        current_time + AUTO_AUTH_TOKEN_EXPIRED_MIN.minutes
      end
  end
end
