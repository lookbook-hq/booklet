module Booklet
  class ScenarioNode < Node
    include Nameable
    include Hideable

    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public
    prop :source, CodeSnippet, reader: :public
    prop :parameters, Array, reader: :public, writer: :public, default: -> { [] }
    prop :display_options, _Nilable(Options), reader: :public, default: -> { {} } do |value|
      Options.from(value)
    end

    def display_options=(options)
      @display_options = Options.from(options.to_h)
    end

    def lookup_value = name

    alias_method :spec, :parent
  end
end
