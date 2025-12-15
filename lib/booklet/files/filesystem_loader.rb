module Booklet
  class FilesystemLoader < Visitor
    node FileNode do |node|
      if node.directory?
        files = Dir[%(#{node.file.path}/*)].sort.map { File.new(_1) }
        files.each do |file|
          visit(node << FileNode.new(file.name, path: file.path))
        end
      end
      node
    end
  end
end
