# frozen_string_literal: true

module Booklet
  class FilesystemLoader < Visitor
    visit DirectoryNode do |node|
      files = Dir[%(#{node.file.path}/*)].sort.map { File.new(_1) }
      files.each do |file|
        node_type = file.directory? ? DirectoryNode : FileNode
        visit(node << node_type.new(file.basename, path: file.path))
      end
      node
    end

    visit FileNode do |node|
      node
    end
  end
end
