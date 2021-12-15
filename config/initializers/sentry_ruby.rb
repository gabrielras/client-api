# frozen_string_literal: true

require 'sentry-ruby'

if Rails.env.production? || Rails.env.sandbox?
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN'] || ''
    # config.environments = %w[development sandbox production]
    # config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  end
end
