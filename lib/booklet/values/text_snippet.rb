# frozen_string_literal: true

module Booklet
  class TextSnippet < Value
    include Values

    prop :raw, String, :positional, reader: :protected

    prop :format, Symbol, reader: :public, default: :markdown do |value|
      value.to_s.underscore.to_sym unless value.nil?
    end

    prop :options, Hash, :**, reader: :protected

    def value
      strip_whitespace(raw)
    end

    alias_method :to_s, :value
  end
end
