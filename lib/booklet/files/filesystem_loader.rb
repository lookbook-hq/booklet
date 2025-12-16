module Booklet
  class FilesystemLoader < Visitor
    node DirectoryNode do |node|
      files = Dir[%(#{node.file.path}/*)].sort.map { File.new(_1) }
      files.each do |file|
        node_type = file.directory? ? DirectoryNode : FileNode
        visit(node << node_type.new(file.name, path: file.path))
      end
      node
    end

    node FileNode do |node|
      node
    end
  end
end
