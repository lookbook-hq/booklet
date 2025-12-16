module Booklet
  class FolderNode < EntityNode
    accept_children_of_type EntityNode.types

    class << self
      def from(file)
        new(file.name, file:)
      end

      def match?(file)
        File.file?(file) && file.directory?
      end
    end
  end
end
