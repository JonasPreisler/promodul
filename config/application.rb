require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Always24
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.action_dispatch.default_headers = config.action_dispatch.default_headers.merge({
            'Content-Security-Policy' =>  "default-src 'self'; img-src 'self'; media-src 'none';" \
                                          "object-src 'none'; script-src 'none'; tyle-src 'none';"
                                                                                          })
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.i18n.enforce_available_locales = true
    config.i18n.available_locales = [:no, :en]
    config.i18n.default_locale = :en
    config.hosts << '5d17-161-49-209-150.ngrok-free.app'

    config.autoload_paths << config.root.join('lib')
  end
end
