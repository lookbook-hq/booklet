# frozen_string_literal: true

module Booklet
  class EntityTransformer < Visitor
    node DirectoryNode do |node|
      directory = FolderNode.new(node.file.name, file: node.file)
      node.children.each { directory << visit(_1) }
      directory
    end

    node FileNode do |node|
      EntityNode.from(node.file)
    end
  end
end
