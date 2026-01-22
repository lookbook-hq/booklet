module Booklet
  class SpecNode < Node
    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public

    permit_child_types ScenarioNode, ProseNode

    def scenarios
      children.grep(ScenarioNode)
    end
  end
end
