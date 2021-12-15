# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integrations::WebhookProviders, type: :enumeration do
  describe '.list' do
    subject { described_class.list }

    it { is_expected.to include('click_sign') }
  end

  describe '.provider_object' do
    it 'returns a new instance from polymorphic provider object' do
      expect(described_class.provider_object('click_sign')).to be_an_instance_of(Integrations::WebhookProviders::ClickSign)
    end
  end

  describe Integrations::WebhookProviders::ClickSign do
    subject(:provider_object) { described_class.new }

    describe '#signature_validator' do
      it 'returns click_sign webhook signature validator' do
        expect(provider_object.signature_validator).to eq ClickSign::WebhookSignatureValidator
      end
    end

    describe '#processor' do
      it 'returns click_sign webhook processor' do
        expect(provider_object.processor).to eq ClickSign::WebhookProcessor
      end
    end
  end
end
