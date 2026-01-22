# frozen_string_literal: true

module Booklet
  class PreviewClassNode < SpecNode
    include Locatable
    include Nameable

    class << self
      def from(path, **props)
        return unless path.to_s.end_with?("_preview.rb")

        new(path, path:, name: FileHelpers.file_name(path), **props)
      end
    end
  end
end
