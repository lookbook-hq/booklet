module Booklet
  class Node < Booklet::Object
    include Enumerable
    include Callbackable
    include Values

    prop :id, String, :positional, reader: :public

    protected attr_reader :parent

    after_initialize do
      @parent = nil
      @children = []
    end

    def ref
      @ref ||= begin
        path_segments = [ancestors&.map(&:ref)&.reverse, id].flatten.compact
        NodeRef(path_segments)
      end
    end

    # @!group Ancestry

    def root
      root = self
      root = root.parent until root.root?
      root
    end

    def root?
      parent.nil?
    end

    def parent=(node)
      @parent = node
      @id = nil
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

    # @!endgroup

    # @!group Descendants

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

    def depth
      ancestors&.size || 0
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

    def has_child?(node)
      children.map(&:id).include?(node.id)
    end

    # @!endgroup

    # @!group Adding children

    def add(node)
      raise ArgumentError, "Only Node instances can be added as children" unless node.is_a?(Node)
      raise ArgumentError, "`#{node.id}` is already a child of node `#{id}`" if has_child?(node)
      raise ArgumentError, "`#{node.id}` is already attached to another node" unless node.root?

      @children << node
      node.parent = self
      node
    end

    alias_method :<<, :add

    # @!endgroup

    # @!group Iteration

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

    # @!endgroup

    # @!group Visting

    def accept(visitor)
      self.class.class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
        def accept(visitor)
        	visitor.visit_#{type}(self)
        end
      RUBY

      accept(visitor)
    end

    # @!endgroup

    # @!group Conversion

    # @!endgroup

    # @!group Type & type checking

    def type
      self.class.type
    end

    def method_missing(name, ...)
      name.end_with?("?") ? type.public_send(name) : super
    end

    def respond_to_missing?(name, ...)
      name.end_with?("?") || super
    end

    # @!endgroup

    # @!group Utilities

    def inspect
      "#<#{self.class.name} @id=#{id}>"
    end

    # @!endgroup

    class << self
      def type
        @type ||= NodeType(name)
      end
    end
  end
end
