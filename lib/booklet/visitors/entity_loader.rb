# frozen_string_literal: true

require "fast_ignore"

module Booklet
  class EntityLoader < Visitor
    prop :registry, _Array(Node), default: [].freeze, writer: :public
    prop :ignore_rules, _Array(String), default: [].freeze, reader: :protected

    after_initialize do
      @path_matcher = FastIgnore.new(ignore_rules:)
    end

    visit DirectoryNode do |node|
      paths = Dir[%(#{node.path}/*)].filter { allowed?(_1) }
      files = paths.sort.map { File.new(_1) }

      files.each do |file|
        child = entity_from_registry(file) || begin
          type = Node.locatable_types.find { _1.from?(file) } || FileNode
          type.from(file)
        end

        visit(child)

        # Don't include empty directories in the tree
        node << child unless child.is_a?(DirectoryNode) && !child.children?
      end
      node
    end

    def with_registry(entities)
      loader = deep_dup
      loader.registry = entities.to_a.map { _1.dup.detatch! }
      loader
    end

    protected def allowed?(path)
      @path_matcher.allowed?(path, include_directories: true)
    end

    protected def entity_from_registry(file)
      node = @registry.find { _1.path == file.path }
      if node && !node.dirty?

        if node.is_a?(DirectoryNode)
          node.children = []
        end
        node
      end
    end
  end
end
