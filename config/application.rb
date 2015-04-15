require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MartyDemo
  class Application < Rails::Application
    ldap_yml = YAML.load_file('ldap.yml')["ldap"]

    config.autoload_paths += %W(#{config.root}/lib)

    config.session_store :cookie_store, :key => '_marty_demo_session'
    # marty requirements
    config.marty                = ActiveSupport::OrderedOptions.new
    config.marty.roles          = [:viewer,:admin,:dev,:user_manager]
    config.marty.class_list     = []

    config.marty.auth_source    = 'ldap'
    config.marty.system_account = 'marty'
    config.marty.local_password = 'marty'
    config.marty.autologin      = 1

   # for ldap authentication.
    config.marty.ldap           = ActiveSupport::OrderedOptions.new
    config.marty.ldap.host      = ldap_yml["host"]
    config.marty.ldap.port      = ldap_yml["port"]
    config.marty.ldap.base_dn   = ldap_yml["base_dn"]
    config.marty.ldap.login     = ldap_yml["login"]
    config.marty.ldap.domain    = ldap_yml["domain"]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
