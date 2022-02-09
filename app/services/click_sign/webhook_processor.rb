# frozen_string_literal: true

module ClickSign
  class WebhookProcessor
    attr_reader :webhook

    def initialize(webhook:)
      @webhook = webhook
    end

    def run
      raise 'Event not expected' if webhook.body['event']['name'].blank?

      return webhook.transition_to!(:ignored) if can_be_ignored?

      webhook.transition_to!(:processing)
      handle_status_change
      webhook.transition_to!(:processed)
    rescue StandardError => e
      handle_error(e)
    end

    private

    def can_be_ignored?
      %w[upload].include?(webhook.body['event']['name'])
    end

    def handle_status_change
      document = Document.find_by(path: webhook.body['document']['path'])

      raise 'Unknown Document' if document.nil?

      document.update!(state: webhook.body['event']['name'])
    end

    def handle_error(error)
      Sentry.capture_message(error.message, level: :fatal, extra: { webhook_id: webhook.id })
      webhook.transition_to!(:failed) if webhook.can_transition_to?(:failed)
    end
  end
end
