# frozen_string_literal: true

require 'benchmark'
require 'rails_helper'

RSpec.describe ClickSign::ProcessRequest, type: :client do
  let(:request_response) { Hash[*Faker::Lorem.words(number: 4)].to_json }

  describe 'Configurations' do
    it 'sets clicksign base api' do
      expect(described_class.base_uri).to eq 'https://sandbox.clicksign.com'
    end
  end

  expected_values = [
    {
      method: 'get',
      body: nil,
      url: "/#{Faker::Lorem.word}"
    },
    {
      method: 'post',
      body: { 'info' => 'info' },
      url: "/#{Faker::Lorem.word}"
    },
    {
      method: 'put',
      body: { 'info' => 'info' },
      url: "/#{Faker::Lorem.word}"
    },
    {
      method: 'delete',
      body: nil,
      url: "/#{Faker::Lorem.word}"
    }
  ]

  expected_values.each do |exp|
    describe "##{exp[:method]}" do
      context 'when request is successfull' do
        before do
          stub_request(
            exp[:method].parameterize.underscore.to_sym, "#{described_class.base_uri}#{exp[:url]}?access_token="
          ).with(body: exp[:body])
            .to_return(status: 200, body: request_response, headers: { 'Content-Type' => 'application/json' })
        end

        it 'refunds transaction' do
          response = described_class.new(body: exp[:body], method: exp[:method], url: exp[:url]).call

          expect(response).to eq JSON.parse(request_response)
        end

        it 'doesn`t capture message via Sentry' do
          expect(Sentry).not_to receive(:capture_message)

          described_class.new(body: exp[:body], method: exp[:method], url: exp[:url]).call
        end
      end

      context 'when request fails' do
        let(:error_message) { 'Transaction error on gateway' }

        before do
          stub_request(
            exp[:method].parameterize.underscore.to_sym, "#{described_class.base_uri}#{exp[:url]}?access_token="
          ).with(body: exp[:body])
            .to_return(status: 500, body: request_response, headers: { 'Content-Type' => 'application/json' })
        end

        it 'captures message via Sentry' do
          expect(Sentry).to receive(:capture_message).with(error_message,
            level: :fatal, extra: { data: { 'code' => 500, 'response' => JSON.parse(request_response) } }
          )

          described_class.new(body: exp[:body], method: exp[:method], url: exp[:url]).call
        end
      end

      context 'when request fails with status code 502' do
        let(:error_message) { 'Transaction error on gateway' }

        before do
          stub_request(
            exp[:method].parameterize.underscore.to_sym, "#{described_class.base_uri}#{exp[:url]}?access_token="
          ).with(body: exp[:body])
            .to_return(status: 502, body: request_response, headers: { 'Content-Type' => 'application/json' })
          allow(Sentry).to receive(:capture_message)
            .with(error_message, level: :fatal,
              extra: { data: { 'code' => 502, 'response' => JSON.parse(request_response) } }
            )
            .and_return(true)
        end

        it 'retry' do
          time = Benchmark.measure do
            described_class.new(body: exp[:body], method: exp[:method], url: exp[:url]).call
          end

          expect(time.real).to be >= 6
        end

        it 'captures message via Sentry' do
          expect(Sentry).to receive(:capture_message).with(error_message,
            level: :fatal, extra: { data: { 'code' => 502, 'response' => JSON.parse(request_response) } }
          )

          described_class.new(body: exp[:body], method: exp[:method], url: exp[:url]).call
        end
      end
    end
  end
end
