module Booklet
  class TextNode < Node
    prop :raw, String, :positional, reader: :public, writer: :public

    def ref = "text_node_#{object_id}"

    def to_ast
      Booklet.markdown.parse(raw)
    end

    def to_html
      Booklet.markdown.format(to_ast)
    end

    def to_s
      raw.to_s
    end
  end
end
