module Booklet
  class ProseNode < ContentNode
    prop :snippet, TextSnippet, :positional, reader: :public, writer: :public do |value|
      TextSnippet.new(value)
    end
  end
end
