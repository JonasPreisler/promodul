#conf = Rails.application.config_for(:redis)['redis_auth_conf'].symbolize_keys

$redis = Redis.new({url: "redis://127.0.0.1:6379/2"})