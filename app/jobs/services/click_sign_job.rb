# frozen_string_literal: true

module Services
  class ClickSignJob < ApplicationJob
    include Sidekiq::Throttled::Worker
    sidekiq_options retry: 1, queue: 'high_priority'

    sidekiq_throttle(
      threshold: { limit: 20, period: 10 }
    )

    def perform(method:, url:, body: {})
      ClickSign::ProcessRequest.new(body: body, method: method, url: url)
    rescue StandardError => e
      Sentry.capture_exception(e, level: :fatal, extra: { body: body, method: method, url: url })
    end
  end
end
