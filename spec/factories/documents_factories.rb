# frozen_string_literal: true

FactoryBot.define do
  factory :document do
    path { Faker::Lorem.words(number: 1) }
    content_base64 { Faker::Lorem.words(number: 1) }
    deadline_at { Time.zone.now }
    auto_close { false }
    sequence_enabled { false }
    remind_interval { 3 }
    state { 'add_signer' }
  end
end
