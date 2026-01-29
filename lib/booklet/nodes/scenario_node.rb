module Booklet
  class ScenarioNode < Node
    include Nameable
    include Hideable

    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public
    prop :source, CodeSnippet, reader: :public
    prop :parameters, Array, reader: :public, writer: :public, default: -> { [] }

    def lookup_value = name
  end
end
