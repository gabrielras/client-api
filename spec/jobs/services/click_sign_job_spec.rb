# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::ClickSignJob, type: :job do
  describe '#perform' do
    let(:body) { {} }
    let(:method) { 'get' }
    let(:url) { 'www.sandbox.com' }
    let(:result) { { response: 'ok' } }

    before do
      allow(ClickSign::ProcessRequest).to receive(:new)
        .with(body: body, method: method, url: url).and_return(result)
    end

    it 'processes webhook with its own processor' do
      expect(ClickSign::ProcessRequest).to receive(:new)

      described_class.perform_now(body: body, method: method, url: url)
    end

    context 'when an error happens' do
      let(:error) { StandardError.new('some error') }

      before do
        allow(ClickSign::ProcessRequest).to receive(:new).and_raise(error)
      end

      it 'captures error with Sentry' do
        expect(Sentry).to receive(:capture_exception)
          .with(error, level: :fatal, extra: { body: body, method: method, url: url })

        described_class.perform_now(body: body, method: method, url: url)
      end
    end
  end
end
