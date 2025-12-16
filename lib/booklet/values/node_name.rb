# frozen_string_literal: true

module Booklet
  class NodeName < Value
    prop :raw, _Union(String, Symbol), :positional

    def value
      raw.to_s
    end

    def to_label
      value.titleize
    end

    def to_param
      value.parameterize
    end

    delegate :to_sym, to: :value

    alias_method :to_s, :value
    alias_method :as_json, :value

    def ==(other)
      case other
      when String
        value <=> other
      when NodeName
        value <=> other.value
      else
        false
      end
    end
  end
end
