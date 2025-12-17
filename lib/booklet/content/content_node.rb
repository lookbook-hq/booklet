module Booklet
  class ContentNode < Node
    class << self
      def types
        [ScenarioNode, ProseNode]
      end
    end
  end
end
