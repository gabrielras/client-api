# frozen_string_literal: true

module Document
  class List < Actor
    output :list, type: Enumerable

    def call
      self.list = Document.all
    end
  end
end
