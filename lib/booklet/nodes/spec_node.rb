module Booklet
  class SpecNode < Node
    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public

    permit_child_types :prose, :scenario

    def label
      name.titleize
    end

    def scenarios
      children.grep(ScenarioNode)
    end
  end
end
