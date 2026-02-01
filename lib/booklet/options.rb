# frozen_string_literal: true

module Booklet
  class Options < ActiveSupport::InheritableOptions
    def initialize(value)
      super(value.to_h.symbolize_keys.transform_values { Options.transform(_1) })
    end

    def to_h
      super.transform_values { Options.hashify(_1) }
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
    end
  end
end
