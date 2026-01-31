# frozen_string_literal: true

require "psych/syntax_error"

module Booklet
  module YARD
    module KeyValueTag
      extend ActiveSupport::Concern

      KEY_VALUE_TAG_REGEX = /^([^\s]+)\s+(.+)$/

      included do
        def value
          Hash[*parts]
        end

        alias_method :to_h, :value

        protected def parts
          @parts ||= begin
            @text.strip.match(KeyValueTag::KEY_VALUE_TAG_REGEX) do |matches|
              key = matches[1]
              value = begin
                YAML.safe_load(matches[2] || "~")
              rescue Psych::SyntaxError
                raise ArgumentError, "Invalid YAML in tag text '#{@text}'"
              end
              return [key.to_sym, value]
            end
            raise ArgumentError, "Could not parse key:value pair from '#{@text}'"
          end
        end
      end
    end
  end
end
