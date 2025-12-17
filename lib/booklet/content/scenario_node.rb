module Booklet
  class ScenarioNode < ContentNode
    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public

    prop :source, CodeSnippet, reader: :public, writer: :public

    prop :parameters, Array, reader: :public, writer: :public, default: [].freeze
  end
end
