module Booklet
  module Values
    def NodeRef(...)
      NodeRef.new(...)
    end

    def NodeName(...)
      NodeName.new(...)
    end

    def NodeType(raw)
      raw.is_a?(Booklet::NodeType) ? raw : NodeType.new(raw)
    end

    extend self
  end
end
