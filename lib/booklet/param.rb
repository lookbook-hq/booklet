# frozen_string_literal: true

module Booklet
  class Param < Booklet::Object
    # PARAM_OPTIONS = %i[label description hint choices]

    prop :name, Symbol, :positional, reader: :public
    prop :label, _Nilable(String), reader: :public, writer: :public
    prop :description, _Nilable(String), reader: :public, writer: :public
    prop :input_options, _Nilable(Options), reader: :public do |value|
      Options.new(value)
    end
    prop :input_name, _Nilable(Symbol), reader: :public, writer: :public
    prop :value_type, _Nilable(Symbol), writer: :public
    prop :value, _Nilable(_Any), writer: :public

    # prop :default_value, _Nilable(_Any)
    # prop :rest, _Nilable(_Any), :**
    # prop :hint, _Nilable(String), reader: :public

    def value_type
      @value_type || guess_value_type
    end

    def input_name
      @input_name || guess_input_name
    end

    def input_choices
      @input_options.fetch(:choices, [])
    end

    # def default_value
    # @default_value ||= begin
    #   return nil unless default_value?
    #   proc {
    #     preview_class_instance.instance_eval(method_parameter_data.value)
    #   }.call
    # end
    # end

    # def default_value_string
    # unless default_value.nil?
    #   ParamValueStringifier.call(default_value)
    # end
    # end

    # def default_value?
    # method_parameter_data.present?
    # end

    # def cast_value(value_str)
    # return value_str unless value_str.is_a?(String)
    # ParamValueParser.call(value_str, value_type)
    # end

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

    # private def method_parameter_data
    # if @scenario.method_parameters[name]
    #   Options.new(name: name, value: @scenario.method_parameters[name])
    # end
    # end

    class << self
      def parse_options(str, context)
        return {} if str.blank?

        opts = if str.start_with?(":")
          resolve_method_options(str, context)
        elsif str.start_with?("{{")
          resolve_eval_options(str, context)
        elsif str[0].in?(["{", "["])
          resolve_yaml_options(str)
        elsif str.match?(/\.(json|yml)$/)
          resolve_file_options
        else
          {}
        end

        opts = opts.is_a?(Array) ? {choices: opts} : opts.to_h
        opts.deep_symbolize_keys!
      end

      # def parse_options_later(...)
      #   -> { Param.parse_options(...) }
      # end

      private def resolve_yaml_options(str)
        YAML.safe_load(str)
      end

      private def resolve_method_options(str, context)
        method_name = str.delete_prefix(":").to_sym
        if context.respond_to?(method_name, true)
          context.send(method_name)
        else
          raise NoMethodError, "Missing param data method `#{method_name}`"
        end
      end

      private def resolve_eval_options(str, context)
        body = options_string[/\{\{\s?(.*)\s?\}\}$/, 1]
        # proc { preview_class_instance.instance_eval(code_str) }.call
        context.instance_eval(body)
      end

      private def resolve_file_options
        raise "Loading scenario options from files is no longer supported"
      end
    end
  end
end
