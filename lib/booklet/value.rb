module Booklet
  class Value < Literal::Data
    include Comparable

    def ==(other)
      return nil if !other.is_a?(self.class)
      value == other.value
    end

    alias_method :eql?, :==
  end
end
