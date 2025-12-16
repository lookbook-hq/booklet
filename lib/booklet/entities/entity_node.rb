module Booklet
  class EntityNode < Node
    prop :file, File, reader: :public, writer: false

    class << self
      def from(file)
        type = EntityNode.types.find { _1.match?(file) }
        type.to_class.from(file)
      end

      def types
        [FolderNode, AnonymousNode].map(&:type)
      end
    end
  end
end
