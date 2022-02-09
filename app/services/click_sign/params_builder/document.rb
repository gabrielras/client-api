# frozen_string_literal: true

require 'base64'

module ClickSign
  module ParamsBuilder
    class Document
      attr_reader :document_id

      ATTRIBUTES = %i[auto_close content_base64 deadline_at locale path sequence_enabled].freeze

      def initialize(document_id)
        @document_id = document_id
      end

      def build
        { document: ATTRIBUTES.index_with { |attribute| send(attribute.to_s) } }
      end

      def auto_close
        true
      end

      def content_base64
        Base64.encode64(open('public/doc.pdf').read)
      end

      def deadline_at
        Date.tomorrow.to_s
      end

      def locale
        'pt-BR'
      end

      def path
        "/Contrato de Prestação de Serviços-#{document_id}.pdf"
      end

      def sequence_enabled
        false
      end
    end
  end
end
