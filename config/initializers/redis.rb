#conf = Rails.application.config_for(:redis)['redis_auth_conf'].symbolize_keys

$redis = Redis.new({url: "redis://#{ENV['REDIS_URL']}:#{ENV['REDIS_PORT']}/#{2}"})
#$redis = Redis.new({url: REDIS_URL})
