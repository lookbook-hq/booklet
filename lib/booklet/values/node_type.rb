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

    def <=>(other)
      if other.is_a?(NodeType)
        value <=> other.value
      elsif other.is_a?(Class)
        to_class <=> other
      else
        to_s <=> other.to_s
      end
    end

    include Comparable
  end
end
