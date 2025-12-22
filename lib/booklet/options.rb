require "active_support/ordered_options"

module Booklet
  class Options < ActiveSupport::InheritableOptions
    def to_h
      transform_values(&self.class.transformer)
    end

    class << self
      def new(options)
        super(options.transform_values(&transformer))
      end

      protected def convert_value(value, wrap = true)
        if !wrap && value.respond_to?(:to_h)
          value.to_h
        elsif wrap && value.respond_to?(:to_h)
          new(value.to_h)
        elsif value.is_a?(Array)
          value.map { convert_value(_1, wrap) }
        else
          value
        end
      end

      protected def transformer
        method(:convert_value)
      end
    end
  end
end
