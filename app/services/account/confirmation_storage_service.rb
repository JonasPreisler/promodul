module Account
  class ConfirmationStorageService
    attr_reader :current_time

    def initialize
      @current_time = Time.now
    end

    def store_user_in_redis(user_account, confirmation)
      value = confirmation ? [user_account.as_json(only: [:id, :username, :active])] + get_users_from_redis : user_account
      key = "user_to_be_confirmed"
      $redis.del(key)
      if value.present?
        $redis.sadd(key, value)
        $redis.expireat(key, (DateTime.now + 1.month).to_i)
      end
    end

    def get_users_from_redis
      users = []
      key = "user_to_be_confirmed"
      result = $redis.smembers(key)
      result.each { |x| users << eval(x)  }
      users
    end

    private

    def build_object_to_save(user_account)
      user_account.as_json()
    end

    def expired_at_time
      current_time + AUTO_AUTH_TOKEN_EXPIRED_MIN.minutes
    end
  end
end