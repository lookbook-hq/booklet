# frozen_string_literal: true

module Booklet
  class CodeSnippet < Value
    prop :raw, String, :positional, reader: :protected

    prop :lang, Symbol, reader: :public, default: :plain do |value|
      value.to_s.underscore.to_sym unless value.nil?
    end

    prop :location, _Nilable(SourceLocation), reader: :public do |value|
      if value.is_a?(Array)
        SourceLocation(*value)
      elsif value.is_a?(String) || value.is_a?(Pathname)
        SourceLocation(value)
      end
    end

    def value
      strip_indent(raw)
    end

    alias_method :to_s, :value
  end
end
