# frozen_string_literal: true

module Booklet
  class Node < Booklet::Object
    include Enumerable
    include Comparable
    include Values

    prop :ref, String, :positional, reader: false do |value|
      value.to_s
    end

    attr_reader :parent
    protected attr_writer :parent

    after_initialize do
      @parent = nil
      @children = []
    end

    def ref
      @node_ref ||= NodeRef(@ref)
    end

    def ref_path(separator: "/")
      @ref_path ||= [ancestors&.map(&:ref)&.reverse, ref].flatten.compact.join(separator)
    end

    def id
      Helpers.hexdigest(ref_path)
    end

    def issues
      @issues ||= IssueLog.new
    end

    def add_warning(*, **)
      issues.add_warning(*, **, node: self)
    end

    def add_error(*, **)
      issues.add_error(*, **, node: self)
    end

    delegate :warnings, :errors, :warnings?, :errors?, to: :issues

    # @!group Ancestry

    def root
      root = self
      root = root.parent until root.root?
      root
    end

    def root?
      parent.nil?
    end

    def detatch
      self.parent = nil
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

    def descendants
      filter { _1 != self }
    end

    def children(&block)
      if block_given?
        @children.each(&block)
        self
      else
        @children.clone
      end
    end

    def remove_child(node)
      return nil unless node

      @children.delete(node)
      node.detatch
      node
    end

    def remove_from_parent
      parent.remove_child(self) unless root?
    end

    def children=(nodes)
      @children.each(&:detatch)
      @children.clear
      push(*nodes)
    end

    delegate :[], to: :children

    def children?
      children.any?
    end

    def depth
      ancestors&.size || 0
    end

    def first_child
      @children.first
    end

    def last_child
      @children.last
    end

    def first_child?
      self == first_child
    end

    def last_child?
      self == last_child
    end

    def has_child?(node)
      children.find { _1.ref == node.ref && _1.type == node.type }
    end

    def leaf?
      !children?
    end

    def branch?
      !leaf?
    end

    # @!endgroup

    # @!group Siblings

    def siblings
      siblings = root? ? [] : parent.children.filter { _1 != self }
      if block_given?
        children.each(&block)
        self
      else
        siblings
      end
    end

    def first_sibling
      root? ? self : parent.children.first
    end

    def first_sibling?
      self == first_sibling
    end

    def last_sibling
      root? ? self : parent.children.last
    end

    def last_sibling?
      self == last_sibling
    end

    def next_sibling
      return nil if root?

      position = parent.children.index(self)
      parent.children.at(position + 1) if position
    end

    def previous_sibling
      return nil if root?

      position = parent.children.index(self)
      parent.children.at(position - 1) if position&.positive?
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

    # @!endgroup

    def validate_child!(node)
      raise ArgumentError, "Only Node instances can be added as children" unless node.is_a?(Node)
      raise ArgumentError, "`#{node.ref}` is already a child of node `#{ref}`" if has_child?(node)
      raise ArgumentError, "`#{node.ref}` is already attached to another node" unless node.root?

      raise ArgumentError, "Parent node does not accept children" if valid_child_types.nil?

      unless valid_child_types.include?(node.type)
        raise TypeError, "Invalid node type '#{node.type}' - must be one of [#{valid_child_types.join(", ")}]"
      end
    end

    def push(*children)
      children.each { add(_1) }
      self
    end

    # @!endgroup

    # @!group Iteration

    def each_node
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

    protected alias_method :each, :each_node

    # @!endgroup

    # @!group Comparison

    def <=>(other)
      return nil if other.nil? || !other.is_a?(Node)

      self_index = root.each_node.to_a.index(self)
      other_index = root.each_node.to_a.index(other)

      return nil if other_index.nil?

      other_index <=> self_index
    end

    # @!group Visting

    def accept(visitor)
      class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
        def accept(visitor)
          visitor.visit_#{type}(self)
        end
      RUBY

      accept(visitor)
    end

    # @!endgroup

    # @!group Type & type checking

    def type
      @type ||= NodeType(self.class)
    end

    def method_missing(name, ...)
      if name.end_with?("?")
        type.public_send(name)
      elsif name.start_with?("each_")
        filter_type = name.to_s.delete_prefix("each_")
        filter { _1.type == filter_type }
      else
        super
      end
    end

    def respond_to_missing?(name, ...)
      name.end_with?("?") || name.start_with?("each_") || super
    end

    # @!endgroup

    # @!group Utilities

    def inspect
      "#<#{self.class.name} @ref=#{ref}>"
    end

    # @!endgroup

    # @!group Child type constraints

    class_attribute :valid_child_types,
      instance_predicate: false,
      default: []

    class_attribute :file_matcher,
      instance_reader: false,
      instance_writer: false,
      instance_predicate: false,
      default: lambda { false }

    def permit_child_types(*args)
      args.flatten!
      self.valid_child_types = args.map { NodeType(_1) } unless args.first.nil?
    end

    class << self
      def permit_child_types(*args)
        args.flatten!
        self.valid_child_types = args.map { NodeType(_1) } unless args.first.nil?
      end

      def type
        NodeType.new(self)
      end

      def match(&block)
        self.file_matcher = block
      end

      def from?(file)
        file_matcher.call(file)
      end

      def locatable?
        false
      end

      def node_types
        Node.subclasses
      end

      def file_node_types
        [FileNode, DirectoryNode]
      end

      def entity_node_types
        node_types.difference(file_node_types)
      end

      def locatable_node_types
        node_types.filter { _1.locatable? }
      end

      def locatable_entity_node_types
        locatable_node_types.difference(file_node_types)
      end
    end

    permit_child_types Node
  end
end
