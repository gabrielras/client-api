# frozen_string_literal: true

module Document
  class Create < Actor
    input :attributes, type: Hash

    output :document, type: Document

    def call
      self.document = Document.create(attributes)

      document.save!
    end
  end
end
