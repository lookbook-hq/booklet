# frozen_string_literal: true

module Booklet
  class Tree < Booklet::Object
    include Enumerable

    prop :updated_at, Time, default: Time.current.freeze, writer: :protected, reader: :public

    def root
      load! unless @root
      @root
    end

    def each(...)
      root.each_node(...)
    end

    alias_method :each_node, :each

    def accept(visitor)
      result = root.accept(visitor)
      result.is_a?(Node) ? self : result
    end

    def issues
      root.accept(IssueAggregator)
    end

    delegate :errors, :warnings, :errors?, :warnings?, to: :issues

    def to_h(...)
      root.accept(HashConverter.new(...))
    end

    def to_ascii(...)
      @root.accept(AsciiTreeRenderer.new(...))
    end

    protected def touch!
      self.updated_at = Time.current
    end
  end
end
