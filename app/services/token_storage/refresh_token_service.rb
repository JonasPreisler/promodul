module TokenStorage
  class RefreshTokenService
    attr_reader :user_id, :data, :current_time, :expired_at_time

    def initialize(user_id, data = {})
      @user_id = user_id
      @data = data
      @current_time = Time.now
    end

    def store_refresh_token(token, jti)
      $redis.mapped_hmset("refresh_#{token}:#{jti}", jti: jti, expiration_time: expired_at_time.to_s)
      # $redis.mapped_hmset("refresh_#{token}:#{jti}", jti: jti)
      $redis.expire("refresh_#{token}:#{jti}", REFRESH_TOKEN_EXPIRED_MIN * 60)
    end

    def find_refresh_token(token)
      keys = $redis.keys("refresh_#{token}:*")
      $redis.hgetall keys[0]
    end

    def refresh_token(old_token)
      keys = $redis.keys("refresh_#{old_token}:*")
      $redis.expire(keys[0],10)
    end

    def delete_refresh_token(old_token)
      keys = $redis.keys("refresh_#{old_token}:*")
      $redis.del keys[0]
    end

    def expired_at_time
      current_time + REFRESH_TOKEN_EXPIRED_MIN.minutes
    end

    private
      def stored_data
        client = DeviceDetector.new(user_agent)

        {
          platform: client.device_type,
          user_id: user_id,
          ip: data[:ip],
          os: client.os_name,
          browser: client.name,
          user_agent: data[:user_agent],
          expired_at: expired_at_time,
          created_at: current_time,
          updated_at: current_time
        }
      end

      def user_agent
        if Rails.env.development?
          'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36'
        else
          data[:user_agent]
        end
      end
  end
end
