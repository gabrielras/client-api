# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClickSign::ParamsBuilder::Document, type: :params_builder do
  subject(:params_builder) { described_class.new(document_id) }

  let(:document_id) { 1 }

  describe 'ATTRIBUTES constant' do
    it 'returns params attributes' do
      expect(described_class::ATTRIBUTES).to eq %i[
        auto_close content_base64 deadline_at locale path sequence_enabled
      ]
    end
  end

  describe '#build' do
    it 'returns all attributes with corresponding methods results' do
      expect(params_builder.build).to eq(
        document: {
          auto_close: params_builder.auto_close,
          content_base64: params_builder.content_base64,
          deadline_at: params_builder.deadline_at,
          locale: params_builder.locale,
          path: params_builder.path,
          sequence_enabled: params_builder.sequence_enabled
        }
      )
    end
  end

  describe '#auto_close' do
    it 'returns auto close' do
      expect(params_builder.auto_close).to eq true
    end
  end

  describe '#content_base64' do
    it 'returns user name' do
      expect(params_builder.content_base64).to eq Base64.encode64(open('public/doc.pdf').read)
    end
  end

  describe '#deadline_at' do
    it 'returns deadline at' do
      expect(params_builder.deadline_at).to eq Date.tomorrow.to_s
    end
  end

  describe '#locale' do
    it 'returns locale' do
      expect(params_builder.locale).to eq 'pt-BR'
    end
  end

  describe '#path' do
    it 'returns path' do
      expect(params_builder.path).to eq "/Contrato de Prestação de Serviços-#{document_id}.pdf"
    end
  end

  describe '#sequence_enabled' do
    it 'returns sequence_enabled' do
      expect(params_builder.sequence_enabled).to eq false
    end
  end
end
