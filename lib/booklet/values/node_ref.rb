# frozen_string_literal: true

module Booklet
  class NodeRef < Value
    prop :segments, _Union(String, _Array(String)), :positional do |value|
      Array.wrap(value)
    end

    prop :default_separator, _String(length: 1), :positional, default: "."

    def digest
      Digest::MD5.hexdigest(to_path)[0..6]
    end

    alias_method :to_s, :digest
    alias_method :value, :digest

    def to_path(separator: default_separator)
      segments.join(separator)
    end

    delegate :to_sym, to: :digest
  end
end
