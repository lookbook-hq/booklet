# frozen_string_literal: true

module Booklet
  class Options < ActiveSupport::InheritableOptions
    def initialize(value)
      super(value.to_h.symbolize_keys.transform_values { Options.transform(_1) })
    end

    def to_h
      super.transform_values { Options.hashify(_1) }
    end

    def to_hash
      to_h
    end

    def merge(*opts)
      Options.new(to_h.merge(*opts.map(&:to_h)))
    end

    delegate :keys, :values, to: :to_h

    class << self
      def transform(value)
        case value
        when Hash
          Options.new(value)
        when Array
          value.map { transform(_1) }
        else
          value
        end
      end

      def hashify(value)
        case value
        when Options
          value.to_h
        when Array
          value.map { hashify(_1) }
        else
          value
        end
      end

      def resolve_from(context, str)
        opts = if str.start_with?(":")
          options_from_method(str, context)
        elsif str.start_with?("{{")
          options_from_context(str, context)
        elsif str[0].in?(["{", "["])
          options_from_yaml(str)
        elsif str.match?(/\.(json|yml)$/)
          raise "Loading options from files is not supported"
        else
          {}
        end

        opts = opts.is_a?(Array) ? {choices: opts} : opts.to_h
        Options.new(opts)
      end

      private def options_from_yaml(str)
        YAML.safe_load(str)
      end

      private def options_from_method(str, context)
        raise "Cannot resolve options without a context" if context.nil?

        method_name = str.delete_prefix(":").to_sym
        if context.respond_to?(method_name, true)
          context.send(method_name)
        else
          raise NoMethodError, "Unknown method `#{method_name}`"
        end
      end

      private def options_from_context(str, context)
        raise "Cannot resolve options without a context" if context.nil?

        body = str[/\{\{\s?(.*)\s?\}\}$/, 1]
        context.instance_eval(body)
      end
    end
  end
end
