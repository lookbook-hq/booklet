# frozen_string_literal: true

require "fast_ignore"

module Booklet
  class FilesystemLoader < Visitor
    prop :ignore_rules, _Array(String), default: [].freeze, reader: :protected

    after_initialize do
      @path_matcher = FastIgnore.new(ignore_rules:)
    end

    visit DirectoryNode do |node|
      paths = Dir[%(#{node.file.path}/*)].filter { allowed?(_1) }
      files = paths.sort.map { File.new(_1) }

      files.each do |file|
        node_type = file.directory? ? DirectoryNode : FileNode
        child = node_type.from(file)
        visit(child)

        # Don't include empty directories in the tree
        node << child unless child.directory? && !child.children?
      end
      node
    end

    protected def allowed?(path)
      @path_matcher.allowed?(path, include_directories: true)
    end
  end
end
