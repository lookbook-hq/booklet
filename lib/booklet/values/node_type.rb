# frozen_string_literal: true

module Booklet
  class NodeType < Value
    prop :raw, _Union(String, Class), :positional

    def value
      raw.to_s.demodulize.underscore.delete_suffix("_node")
    end

    def enquirer
      ActiveSupport::StringInquirer.new(value)
    end

    def pluralize
      value.pluralize
    end

    def to_class
      raw.is_a?(Class) ? raw : "booklet/#{value}_node".classify.constantize
    end

    def method_missing(name, ...)
      name.end_with?("?") ? enquirer.public_send(name) : super
    end

    def respond_to_missing?(name, ...)
      name.end_with?("?") || super
    end

    def match?(arg)
      to_class.match?(arg)
    end

    alias_method :to_s, :value
    alias_method :to_param, :value
    alias_method :as_json, :value

    delegate :to_sym, to: :value

    def ==(other)
      case other
      when NodeType
        value == other.value
      when Class
        to_class == other
      else
        false
      end
    end
  end
end
