# frozen_string_literal: true

require 'json'

module ClickSign
  class ProcessRequest
    include HTTParty

    base_uri 'https://sandbox.clicksign.com'

    attr_reader :body, :method, :url

    def initialize(method:, url:, body: {})
      @body = body
      @method = method
      @url = url
    end

    def call
      retry_block do
        response = self.class.send(method.parameterize.underscore.to_sym, url_with_access_token, body: body)
        response.success? ? response.parsed_response : httparty_error(response)
      end
    end

    private

    def retry_block
      retries ||= 0
      yield
    rescue HTTParty::Error => e
      error = JSON.parse(e.message.gsub('=>', ': '))
      return handle_error(error) if !retry_status_code(error['code']) || retries >= 2

      retries += 1
      sleep 3
      retry
    rescue StandardError => e
      Sentry.capture_message('StandardError', { level: :fatal, extra: { data: e } })
    end

    def access_token
      ENV['CLICKSIGN_CLIENT_KEY']
    end

    def handle_error(error)
      Sentry.capture_message('Transaction error on gateway', { level: :fatal, extra: { data: error } })
    end

    def httparty_error(error)
      error_response = "{ \"code\": #{error.code},\"response\": #{error.parsed_response}}"
      raise HTTParty::Error, error_response
    end

    def retry_status_code(status_code)
      [502].include?(status_code)
    end

    def url_with_access_token
      url.to_s + "?access_token=#{access_token}"
    end
  end
end
