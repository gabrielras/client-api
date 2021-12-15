# frozen_string_literal: true

module ClientAPI
  class BaseAPI < Grape::API
    cascade false

    mount ClientAPI::V1::BaseAPI
  end
end
