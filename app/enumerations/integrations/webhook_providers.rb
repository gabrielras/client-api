# frozen_string_literal: true

module Integrations
  class WebhookProviders < EnumerateIt::Base
    associate_values(:click_sign)

    def self.provider_object(provider_name)
      provider_object_class_name = provider_name.camelize
      const_get(provider_object_class_name).new
    end

    class ClickSign
      def signature_validator
        ::ClickSign::WebhookSignatureValidator
      end

      def processor
        ::ClickSign::WebhookProcessor
      end
    end
  end
end
