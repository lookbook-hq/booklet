# frozen_string_literal: true

module Booklet
  class Tree < Booklet::Object
    include Enumerable

    attr_reader :root

    prop :files, DirectoryNode, :positional, reader: :public
    prop :transformer, _Union(Visitor, _Class(Visitor)), :positional

    after_initialize do
      @root = files.accept(@transformer)
    end

    def accept(visitor)
      result = @root.accept(visitor)
      result.is_a?(Node) ? self : result
    end

    def issues
      @root.accept(IssueAggregator)
    end

    delegate :errors, :warnings, :errors?, :warnings?, to: :issues

    def to_h
      @root.accept(HashConverter)
    end

    def to_ascii
      @root.accept(AsciiTreeRenderer)
    end

    def each(...)
      @root.each_node(...)
    end

    alias_method :each_node, :each

    class << self
      def from(files, transformer = Booklet.transformer, visitors: Booklet.visitors)
        tree = new(files, transformer)
        visitors.each { tree.accept(_1) }
        tree
      end
    end
  end
end
