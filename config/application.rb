require_relative 'boot'

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GovukServicesPrototype
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be
    # autoloadable.
    config.autoload_paths += %W[
      #{config.root}/lib
      app/controllers/segment_constraints
    ]

    config.middleware.use 'ContentItemAppender'
    config.middleware.use 'PathLogger'
    config.middleware.insert_after ActionDispatch::Executor, 'GovukUrlReplacer'
  end
end
