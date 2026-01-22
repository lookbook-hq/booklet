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
      paths = paths.sort.map { Pathname(_1) }

      paths.each do |path|
        child = entity_from_registry(path) || entity_from_path(path)
        next unless child
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

    protected def entity_from_path(path)
      stack = Node.descendants.filter { _1 < Locatable }

      until stack.none?
        entity = stack.pop.from(path)
        return entity if entity
      end
    end

    protected def entity_from_registry(path)
      node = @registry.find { _1.path == path }
      if node && !node.dirty?
        if node.is_a?(DirectoryNode)
          node.children = []
        end
        node
      end
    end
  end
end
