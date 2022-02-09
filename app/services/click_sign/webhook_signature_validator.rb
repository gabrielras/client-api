# frozen_string_literal: true

module ClickSign
  class WebhookSignatureValidator
    def self.valid?(headers:, raw_data: {}, body: {})
      hash = OpenSSL::HMAC.hexdigest('SHA256', ENV['SECRET_CLICK_SIGN'], raw_data)
      raw_signature = headers['X-Hub-Signature'].to_s

      hash == raw_signature
    end
  end
end
