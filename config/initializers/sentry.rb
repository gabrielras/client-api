# frozen_string_literal: true

require 'sentry-ruby'
require 'sentry-rails'

if Rails.env.production? || Rails.env.sandbox?
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.breadcrumbs_logger = %i[active_support_logger]
  end
end
