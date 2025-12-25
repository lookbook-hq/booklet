# frozen_string_literal: true

module Booklet
  class EntityNode < Node
    prop :file, File, reader: :public, writer: false

    def label
      name.titleize
    end

    class << self
      def from(file)
        new(file.name, file:)
      end

      def types
        [FolderNode, SpecNode, DocumentNode, AssetNode, AnonNode]
      end
    end
  end
end
