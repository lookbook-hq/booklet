# frozen_string_literal: true

module Booklet
  class DocumentNode < Node
    include Locatable
    include Nameable

    EXTENSIONS = [".md", ".md.erb"]

    class << self
      def from(path, **props)
        path = Pathname(path)

        return unless FileHelpers.extension(path).in?(EXTENSIONS)

        new(path, path:, name: FileHelpers.file_name(path), **props)
      end
    end
  end
end
