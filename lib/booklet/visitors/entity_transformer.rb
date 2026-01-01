# frozen_string_literal: true

module Booklet
  class EntityTransformer < Visitor
    # LOCATABLE_ENTITIES = [FolderNode, SpecNode, DocumentNode, AssetNode, AnonNode]

    visit DirectoryNode do |node|
      folder = FolderNode.new(node.file.basename, file: node.file)
      node.children.each { folder << visit(_1) }
      folder
    end

    visit FileNode do |node|
      type = Node.locatable_entity_node_types.find { _1.from?(node.file) }
      type.from(node.file)
    end
  end
end
