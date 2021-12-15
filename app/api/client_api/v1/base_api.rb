# frozen_string_literal: true
module ClientAPI
  module V1
    class BaseAPI < Grape::API
      format :json
      version :v1, using: :path

      helpers ClientAPI::V1::Helpers::RequestHelpers

      rescue_from ActiveRecord::RecordInvalid do |e|
        error!({ errors: e.record.errors.messages }, 422)
      end

      rescue_from ActiveRecord::RecordNotDestroyed do |e|
        error!({ errors: e.record.errors.messages }, 403)
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!({ errors: e.full_messages }, 400)
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        error!({ error: e.message }, 404)
      end

      rescue_from :all do |e|
        raise e unless Rails.env.production?

        Sentry.capture_exception(e)

        error!({ error: 'Internal server error' }, 500)
      end

      mount ClientAPI::V1::Integrations::BaseAPI
    end
  end
end
