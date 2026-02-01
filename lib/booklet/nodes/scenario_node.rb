module Booklet
  class ScenarioNode < Node
    include Nameable
    include Hideable
    include AcceptsParams
    include AcceptsDisplayOptions

    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public
    prop :source, CodeSnippet, reader: :public
    prop :method_parameters, Array, reader: :public, writer: :public, default: -> { [] }

    def display_options
      Options.new(@display_options)
    end

    def params
      @params.uniq { _1[:name] }.map do |param_data|
        ScenarioParam.new(**param_data)
      end
    end

    def lookup_value = name

    alias_method :spec, :parent
  end
end
