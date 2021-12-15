# frozen_string_literal: true

module ClientAPI
  module V1
    module Integrations
      class BaseAPI < Grape::API
        namespace 'integrations' do
          mount ClientAPI::V1::Integrations::WebhooksAPI
        end
      end
    end
  end
end
