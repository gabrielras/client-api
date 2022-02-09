# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClickSign::Client::Document, type: :client do
  subject(:client) { described_class.new }

  let(:base_uri) { 'https://sandbox.clicksign.com' }

  describe '#create' do
    let(:document_builder) { { document: 'document' } }
    let(:url) { '/api/v1/documents' }
    let(:method) { 'post' }

    it 'response' do
      expect(Services::ClickSignJob).to receive(:perform_now).with(
        body: document_builder,
        method: 'post',
        url: '/api/v1/documents'
      )

      client.create(document_builder)
    end
  end

  describe '#list' do
    let(:document_builder) { { document: 'document' } }
    let(:url) { '/api/v1/documents' }
    let(:method) { 'get' }

    it 'response' do
      expect(Services::ClickSignJob).to receive(:perform_now).with(
        method: 'get',
        url: '/api/v1/documents'
      )
      client.list
    end
  end
end
