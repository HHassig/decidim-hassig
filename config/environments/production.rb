require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  config.hosts = [
    "decidim.hassig.com",
    "0.0.0.0",
    "localhost",
    /.*\.internal$/,
    /^[a-f0-9]{12}(:[0-9]+)?$/,
    IPAddr.new("10.0.0.0/8"),
    IPAddr.new("172.16.0.0/12"),
    IPAddr.new("192.168.0.0/16")
  ]

  # SSL Configuration - IMPORTANT for Kamal proxy setup
  config.force_ssl = true
  config.ssl_options = {
    redirect: {
      exclude: ->(request) {
        request.path == "/up" ||
        request.path == "/kamal-health" ||
        (request.path == "/kamal-health" && request.host.include?("0.0.0.0"))
      }
    }
  }

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.asset_host = ENV['RAILS_ASSET_HOST'] if ENV['RAILS_ASSET_HOST'].present?
  config.active_storage.service = Rails.application.secrets.dig(:storage, :provider) || :local
  config.log_level = %w(debug info warn error fatal).include?(ENV['RAILS_LOG_LEVEL']) ? ENV['RAILS_LOG_LEVEL'] : :info
  config.log_tags = [ :request_id ]
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.log_formatter = ::Logger::Formatter.new

  config.action_mailer.smtp_settings = {
    :address        => Rails.application.secrets.smtp_address,
    :port           => Rails.application.secrets.smtp_port,
    :authentication => Rails.application.secrets.smtp_authentication,
    :user_name      => Rails.application.secrets.smtp_username,
    :password       => Rails.application.secrets.smtp_password,
    :domain         => Rails.application.secrets.smtp_domain,
    :enable_starttls_auto => Rails.application.secrets.smtp_starttls_auto,
    :openssl_verify_mode => 'none'
  }

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false
end