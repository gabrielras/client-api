# frozen_string_literal: true

module ClickSign
  module Client
    class Document
      def create(document_builder)
        Services::ClickSignJob.perform_now(body: document_builder, method: 'post', url: '/api/v1/documents')
      end

      def list
        Services::ClickSignJob.perform_now(method: 'get', url: '/api/v1/documents')
      end
    end
  end
end
