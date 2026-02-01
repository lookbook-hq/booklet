module Booklet
  class ScenarioNode < Node
    include Nameable
    include Hideable
    include AcceptsParams
    include AcceptsDisplayOptions

    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public
    prop :source, _Nilable(CodeSnippet), reader: :public, writer: :public
    prop :context, _Nilable(Class), reader: :public, writer: :public

    def display_options
      Options.new(@display_options)
    end

    def lookup_value = name

    alias_method :spec, :parent
  end
end
