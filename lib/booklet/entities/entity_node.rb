# frozen_string_literal: true

module Booklet
  class EntityNode < Node
    prop :file, File, reader: :public, writer: false

    class << self
      def from(file)
        new(file.name, file:)
      end

      def subclasses
        [FolderNode, SpecNode, DocumentNode, AssetNode, AnonNode]
      end
    end
  end
end
