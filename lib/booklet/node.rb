module Booklet
  class Node < Booklet::Object
    include Enumerable

    prop :id, String, :positional, reader: :public

    protected attr_accessor :parent

    after_initialize do
      @parent = nil
      @children = []
    end

    def root
      root = self
      root = root.parent until root.root?
      root
    end

    def root?
      parent.nil?
    end

    def depth
      ancestors&.size || 0
    end

    def children(&block)
      if block_given?
        @children.each(&block)
        self
      else
        @children.clone
      end
    end

    delegate :[], to: :children

    def children?
      !@children.empty?
    end

    def ancestors
      return nil if root?

      ancestors = []
      prev_parent = parent
      while prev_parent
        ancestors << prev_parent
        prev_parent = prev_parent.parent
      end
      ancestors
    end

    def descendants
      filter { _1 != self }
    end

    def leaf?
      children.any?
    end

    def branch?
      !leaf?
    end

    def <<(node)
      add node
    end

    def add(node)
      unless node.is_a?(Node)
        raise ArgumentError, "Only Node instances can be added as children"
      end

      @children << node
      node.parent = self
      node
    end

    def each
      return to_enum unless block_given?

      node_stack = [self]
      until node_stack.empty?
        current = node_stack.shift
        next unless current
        yield current
        node_stack = current.children.concat(node_stack)
      end

      self if block_given?
    end
  end
end
