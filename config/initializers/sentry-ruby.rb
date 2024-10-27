# frozen_string_literal: true

Sentry.init do |config|
  config.release = Rails.root.join('.version').read.strip if Rails.root.join('.version').exist?
  config.traces_sample_rate = 1.0
  config.profiles_sample_rate = 1.0
  config.breadcrumbs_logger = %i[sentry_logger http_logger active_support_logger]
  config.excluded_exceptions += [
    'Rack::Utils::InvalidParameterError' # Rack was unable to decode a parameter
  ]
  config.before_send_transaction = ->(event, _hint) do
    duration = event.timestamp - event.start_timestamp
    event if duration > 25.seconds
  end
end
