require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests
  config.enable_reloading = false

  # Eager load code on boot
  config.eager_load = true

  # Disable full error reports
  config.consider_all_requests_local = false

  # Enable caching
  config.action_controller.perform_caching = true

  # Cache static files
  config.public_file_server.headers = {
    "cache-control" => "public, max-age=#{1.year.to_i}"
  }

  # ✅ IMPORTANT for Render (serve static files)
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Assets
  config.assets.compile = false
  config.assets.prefix = "/assets"

  # SSL
  config.assume_ssl = true
  config.force_ssl = true

  # Logs
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Silence health check logs
  config.silence_healthcheck_path = "/up"

  # No deprecation logs
  config.active_support.report_deprecations = false

  # ✅ SIMPLE CACHE (safe for deployment)
  config.cache_store = :memory_store

  # ✅ SIMPLE JOB QUEUE (safe for deployment)
  config.active_job.queue_adapter = :async

  # Active Storage
  config.active_storage.service = :local

  # Mailer (you can update later)
  config.action_mailer.default_url_options = { host: "your-app.onrender.com" }

  # I18n fallbacks
  config.i18n.fallbacks = true

  # Do not dump schema
  config.active_record.dump_schema_after_migration = false

  # Minimal inspect
  config.active_record.attributes_for_inspect = [:id]

  # ✅ FIX: Allow Render domain
  config.hosts << ".onrender.com"
end