# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClickSign::WebhookSignatureValidator, type: :lib do
  describe '.valid?' do
    let(:api_key) { Faker::Lorem.word }
    let(:headers) { { 'X-Hub-Signature' => signature } }
    let(:raw_data) { Faker::Lorem.paragraph }

    before do
      stub_const 'ENV', ENV.to_h.merge('SECRET_CLICK_SIGN' => api_key)
    end

    context 'when signature is valid' do
      let(:signature) { OpenSSL::HMAC.hexdigest('SHA256', api_key, raw_data) }

      it 'returns true' do
        expect(described_class.valid?(headers: headers, raw_data: raw_data)).to be(true)
      end
    end

    context 'when signature is invalid' do
      let(:signature) { 'FAKE SIGNATURE' }

      it 'returns false' do
        expect(described_class.valid?(headers: headers, raw_data: raw_data)).to be(false)
      end
    end
  end
end
