# frozen_string_literal: true

module Booklet
  class EntityTransformer < Visitor
    prop :registry, _Array(Node), default: [].freeze, writer: :public

    visit DirectoryNode do |node|
      folder = FolderNode.new(node.file.basename, file: node.file)
      node.children.each { folder << visit(_1) }
      folder
    end

    visit FileNode do |node|
      entity_from_registry(node) || begin
        type = Node.locatable_entity_node_types.find { _1.from?(node.file) } || AnonNode
        type.from(node.file)
      end
    end

    # protected def node_types
    #   Node.locatable_entity_node_types.except { _1 == AnonNode } + [AnonNode]
    # end

    protected def entity_from_registry(file)
      node = @registry.find { _1.path == file.path }
      if node && !node.dirty?
        node.deep_dup.detatch!
      end
    end
  end
end
