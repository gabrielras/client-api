# frozen_string_literal: true

class Document < ApplicationRecord
  validates :content_base64, presence: true
  validates :deadline_at, presence: true
  validates :path, presence: true
  validates :content_base64, presence: true
  validates :deadline_at, presence: true
  validates :remind_interval, presence: true
end
