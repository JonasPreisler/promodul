#conf = Rails.application.config_for(:redis)['redis_auth_conf'].symbolize_keys
uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://127.0.0.1:6379/2" )
$redis = Redis.new({url: uri})
#$redis_auth = Redis.new({url: "redis://#{conf[:host]}:#{conf[:port]}/#{conf[:db]}"})
#$redis_helper = Redis.new({url: "redis://#{conf_stat[:host]}:#{conf_stat[:port]}/#{conf_stat[:db]}"})
#$redis_rate_limit = Redis.new({url: "redis://#{conf_rate[:host]}:#{conf_rate[:port]}/#{conf_rate[:db]}"})