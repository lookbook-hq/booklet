module Booklet
  class TextNode < Node
    prop :raw, String, :positional, reader: :protected
    prop :markdown, _Boolean, reader: :public, default: true

    def ref = Helpers.hexdigest(raw)

    def to_s = raw
  end
end
