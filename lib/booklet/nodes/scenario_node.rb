module Booklet
  class ScenarioNode < Node
    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public
    prop :source, CodeSnippet, reader: :public, writer: :public
    prop :parameters, Array, reader: :public, writer: :public, default: [].freeze

    alias_method :name, :ref

    def label
      name.titleize
    end
  end
end
