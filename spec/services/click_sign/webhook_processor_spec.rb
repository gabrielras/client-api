# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClickSign::WebhookProcessor, type: :client do
  describe '#run' do
    subject(:webhook_processor) { described_class.new(webhook: webhook) }

    let(:webhook) do
      create(:integrations_webhook, :received,
        body: {
          event: {
            name: webhook_event,
            data: {
              user: {
                email: 'email@empresa.com',
                name: 'Empresa de Teste'
              },
              account: {
                key: '35286aca-beef-490d-ad23-bc5e78441232'
              },
              signers: [
                {
                  key: 'c9d50ca2-543f-49ee-924a-345f23088434',
                  request_signature_key: 'c08a5ed5-3c74-987c-830f-ae9b9ddd7b85',
                  email: 'email@empresa.com',
                  created_at: '2018-04-24T22:42:40.180-03:00',
                  sign_as: 'witness',
                  auths: [
                    'sms'
                  ],
                  phone_number: '11987654321',
                  phone_number_hash: '66e0c202cea2d29452067233e8e0f8fe2808cca773852ab537e40cf4a68d16ae'
                }
              ]
            },
            occurred_at: '2018-04-25T01:42:40.197Z'
          },
          document: {
            path: document.path
          },
          signers: [],
          events: []
        }
      )
    end

    let(:document) { create(:document) }
    let(:webhook_event) { 'add_signer' }

    context 'when action processing success' do
      let(:webhook_status) { 'add_signer' }

      before do
        webhook.body['document']['path'] = document.path
      end

      it 'webhook is processed' do
        webhook_processor.run

        expect(webhook.reload).to be_in_state(:processed)
      end

      it 'updated state document' do
        webhook_processor.run

        expect(document.state).to eq 'add_signer'
      end
    end

    context 'when webhook current status is upload' do
      let(:webhook_status) { 'upload' }

      before do
        allow(webhook_processor).to receive(:can_be_ignored?).and_return(true) # rubocop:disable RSpec/SubjectStub
      end

      it 'webhook is ignored' do
        webhook_processor.run

        expect(webhook.reload).to be_in_state(:ignored)
      end
    end

    context 'when action processing fails' do
      before do
        webhook.body['event']['name'] = nil
      end

      it 'handles error with Sentry' do
        expect(Sentry).to receive(:capture_message)
          .with('Event not expected', level: :fatal, extra: { webhook_id: webhook.id })

        webhook_processor.run
      end

      it 'transitions webhook state to failed' do
        webhook_processor.run

        expect(webhook.reload).to be_in_state(:failed)
      end
    end
  end
end
