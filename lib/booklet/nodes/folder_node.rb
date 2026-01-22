# frozen_string_literal: true

module Booklet
  class FolderNode < Node
    include Nameable
    include Locatable

    permit_child_types [FolderNode, AssetNode, BookletSpecNode, DocumentNode, PreviewClassNode, SpecNode, FileNode]

    def directory?
      true
    end

    class << self
      def from(path, **props)
        path = Pathname(path)

        return unless FileHelpers.directory?(path)

        new(path, path:, name: FileHelpers.file_name(path), **props)
      end
    end
  end
end
