# frozen_string_literal: true

module Booklet
  class NodeRef < Booklet::Data
    prop :raw, String, :positional, reader: :public

    def value
      Helpers.hexdigest(raw)
    end

    alias_method :to_s, :value
    delegate :to_sym, to: :value

    def ==(other)
      if other.is_a?(NodeRef)
        other.value == value
      else
        [raw, value].include?(other)
      end
    end
  end
end
