module TokenStorage
  class JtiService
    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def store_jti_token(jti_token)
      $redis.set("access_#{user_id}:#{jti_token}", jti_token)
      $redis.expire("access_#{user_id}:#{jti_token}", JWT_TOKEN_EXPIRED_MIN*60)
    end

    def delete_jti_token(jti_token)
      $redis.del("access_#{user_id}:#{jti_token}")
    end
  end
end
