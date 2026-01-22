# frozen_string_literal: true

module Booklet
  class AssetNode < Node
    include Locatable

    MIME_TYPES = %w[text/css text/javascript]

    class << self
      def from(path, **props)
        path = Pathname(path)
        mime_type = FileHelpers.mime_type(path)

        return if FileHelpers.directory?(path)
        return unless mime_type.in?(MIME_TYPES) || mime_type.start_with?("image/")

        new(path, path:, **props)
      end
    end
  end
end
