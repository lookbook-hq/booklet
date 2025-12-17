# frozen_string_literal: true

module Booklet
  class Value < Literal::Data
    include Comparable
    include Values
    include Helpers

    def ==(other)
      return nil if !other.is_a?(self.class)
      value == other.value
    end

    alias_method :eql?, :==
  end
end
