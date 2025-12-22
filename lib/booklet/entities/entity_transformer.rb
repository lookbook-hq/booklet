# frozen_string_literal: true

module Booklet
  class EntityTransformer < Visitor
    visit DirectoryNode do |node|
      folder = FolderNode.new(node.file.name, file: node.file)
      node.children.each { folder << visit(_1) }
      folder
    end

    visit FileNode do |node|
      type = EntityNode.types.find { _1.matches?(node.file) }
      type.from(node.file)
    end
  end
end
