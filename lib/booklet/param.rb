# frozen_string_literal: true

module Booklet
  class Param < Booklet::Object
    prop :name, Symbol, :positional, reader: :public
    prop :label, _Nilable(String), writer: :public
    prop :description, _Nilable(String), reader: :public, writer: :public
    prop :input_name, _Nilable(Symbol), writer: :public
    prop :value_type, _Nilable(Symbol), writer: :public
    prop :default_value, _Nilable(_Any)
    prop :value, _Nilable(_Any), writer: :protected
    prop :required, _Boolean, writer: :public, default: false
    prop :input_options, Hash, :**, reader: :public, default: -> { {} }

    def label
      @label ||= name.to_s.titleize
    end

    def with_value(value)
      deep_dup.tap do |param|
        param.value = Param.cast_string_value(value, value_type)
      end
    end

    def value
      @value || @default_value
    end

    def value_type
      @value_type || guess_value_type
    end

    def default_value
      @default_value.respond_to?(:call) ? @default_value.call : @default_value
    end

    def input_name
      @input_name || guess_input_name
    end

    def input_choices
      @input_options.fetch(:choices, [])
    end

    def required? = !!@required

    private def guess_input_name
      if @value_type == :boolean || (@value_type.nil? && Helpers.boolean?(value))
        :checkbox
      else
        :text
      end
    end

    private def guess_value_type
      if input_name.in?([:toggle, :checkbox])
        :boolean
      elsif input_name == :number
        :integer
      elsif Helpers.boolean?(value)
        :boolean
      elsif value.is_a?(Symbol)
        :symbol
      elsif input_name.in?([:date, :"datetime-local"]) || value.is_a?(DateTime)
        :datetime
      else
        :string
      end
    end

    class << self
      def cast_string_value(value, type)
        return value unless value.is_a?(String)

        type = type.to_s.downcase
        cast_method = :"cast_to_#{type}"
        raise ArgumentError, "Unable to cast to `#{type}`" unless respond_to?(cast_method, true)

        send(cast_method, value)
      end

      protected def cast_to_string(value) = value.to_s

      protected def cast_to_symbol(value)
        value.delete_prefix(":").to_sym if value.present?
      end

      protected def cast_to_datetime(value) = DateTime.parse(value)

      protected def cast_to_boolean(value) = active_model_cast(value, :boolean)

      protected def cast_to_integer(value) = active_model_cast(value, :integer)

      protected def cast_to_float(value) = active_model_cast(value, :integer)

      protected def cast_to_hash(value)
        result = YAML.safe_load(value)
        raise "'#{value}' is not a YAML Hash" unless result.is_a?(Hash)
        result
      end

      protected def cast_to_array(value)
        result = YAML.safe_load(value)
        raise "'#{value}' is not a YAML Array" unless result.is_a?(Array)
        result
      end

      private def active_model_cast(value, type)
        type_class = "ActiveModel::Type::#{type.to_s.camelize}".constantize
        type_class.new.cast(value)
      end
    end
  end
end
