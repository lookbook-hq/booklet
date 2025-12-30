# frozen_string_literal: true

module Booklet
  class AssetNode < Node
    include Locatable

    MIME_TYPES = %w[text/css text/javascript]

    match do |file|
      return if file.directory?

      file.mime_type.in?(MIME_TYPES) || file.mime_type.start_with?("image/")
    end
  end
end
