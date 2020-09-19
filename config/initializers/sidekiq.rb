#conf_sidekiq = Rails.application.config_for(:redis)['redis_sidekiq'].symbolize_keys
#
#Sidekiq.configure_server do |config|
#  config.redis = {url: "redis://#{conf_sidekiq[:host]}:#{conf_sidekiq[:port]}/#{conf_sidekiq[:db]}"}
#end
#
#Sidekiq.configure_client do |config|
#  config.redis = {url: "redis://#{conf_sidekiq[:host]}:#{conf_sidekiq[:port]}/#{conf_sidekiq[:db]}"}
#end
#
##Sidekiq.default_worker_options = { retry: 1}
