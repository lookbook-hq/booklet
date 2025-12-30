module Booklet
  class ProseNode < Node
    prop :snippet, TextSnippet, :positional, reader: :public, writer: :public do |value|
      TextSnippet.new(value)
    end
  end
end
