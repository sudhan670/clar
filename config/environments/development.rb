require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Reload code on every request (development only)
  config.enable_reloading = true
  config.eager_load = false

  # Show full error reports
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Caching (toggle with rails dev:cache)
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.public_file_server.headers = {
      "cache-control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
  end

  # Simple cache store
  config.cache_store = :memory_store

  # Active Storage (local)
  config.active_storage.service = :local

  # Mailer settings
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = {
    host: "localhost",
    port: 3000
  }

  # Deprecation logs
  config.active_support.deprecation = :log

  # Raise error if migrations are pending
  config.active_record.migration_error = :page_load

  # Verbose logs
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true
  config.active_job.verbose_enqueue_logs = true

  # View annotations
  config.action_view.annotate_rendered_view_with_filenames = true

  # Raise error for missing callback actions
  config.action_controller.raise_on_missing_callback_actions = true
end