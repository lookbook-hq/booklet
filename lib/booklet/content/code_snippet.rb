# frozen_string_literal: true

module Booklet
  class CodeSnippet < Booklet::Data
    prop :raw, String, :positional, reader: :protected

    prop :lang, Symbol, reader: :public, default: :plain do |value|
      value.to_s.underscore.to_sym unless value.nil?
    end

    prop :location, _Nilable(SourceLocation), reader: :public do |value|
      if value.is_a?(Array)
        SourceLocation.new(*value)
      elsif value.is_a?(String) || value.is_a?(Pathname)
        SourceLocation.new(value)
      end
    end

    def value = raw.strip_heredoc

    alias_method :to_s, :value
  end
end
