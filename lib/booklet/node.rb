# frozen_string_literal: true

module Booklet
  class Node < Booklet::Object
    include Enumerable
    include Comparable
    include Callbackable
    include Values

    prop :name, NodeName, :positional, reader: :public do |value|
      NodeName(value) unless value.nil?
    end

    protected attr_reader :parent

    after_initialize do
      @parent = nil
      @children = []
    end

    def ref
      @ref ||= begin
        path_segments = [ancestors&.map(&:ref)&.reverse, name.to_s].flatten.compact
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
      @name = nil
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
      valid_child_types.nil?
    end

    def branch?
      !leaf?
    end

    def has_child?(node)
      children.map(&:name).include?(node.name)
    end

    # @!endgroup

    # @!group Adding children

    def add(node)
      validate_child!(node)

      @children << node
      node.parent = self
      node
    end

    alias_method :<<, :add

    def validate_child!(node)
      raise ArgumentError, "Only Node instances can be added as children" unless node.is_a?(Node)
      raise ArgumentError, "`#{node.name}` is already a child of node `#{name}`" if has_child?(node)
      raise ArgumentError, "`#{node.name}` is already attached to another node" unless node.root?

      raise ArgumentError, "Cannot add children to a leaf node" if valid_child_types.nil?

      unless valid_child_types.include?(node.type)
        raise TypeError, "Invalid node type '#{node.type}' - must be one of [#{valid_child_types.join(", ")}]"
      end
    end

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
      "#<#{self.class.name} @name=#{name}>"
    end

    # @!endgroup

    # @!group Child type constraints

    class_attribute :valid_child_types,
      instance_reader: true,
      instance_writer: true,
      instance_predicate: false,
      default: nil

    def accept_children_of_type(*args)
      args.flatten!
      self.valid_child_types = args.map { NodeType(_1) } unless args.first.nil?
    end

    class << self
      def type
        @type ||= NodeType(name)
      end

      def accept_children_of_type(*args)
        args.flatten!
        self.valid_child_types = args.map { NodeType(_1) } unless args.first.nil?
      end
    end

    accept_children_of_type Node
  end
end
