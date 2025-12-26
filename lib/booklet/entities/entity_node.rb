# frozen_string_literal: true

module Booklet
  class EntityNode < Node
    prop :file, File, reader: :public, writer: false

    delegate :name, to: :file

    def label
      name.titleize
    end

    class << self
      include Helpers

      def from(file)
        new(file.path, file:)
      end

      def types
        [FolderNode, SpecNode, DocumentNode, AssetNode, AnonNode]
      end
    end
  end
end
