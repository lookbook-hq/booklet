# frozen_string_literal: true

module Booklet
  module Values
    def NodeRef(...)
      NodeRef.new(...)
    end

    def NodeName(...)
      NodeName.new(...)
    end

    def NodeType(...)
      NodeType.new(...)
    end

    def Snippet(...)
      Snippet.new(...)
    end

    def MethodSnippet(...)
      MethodSnippet.new(...)
    end

    def SourceLocation(...)
      SourceLocation.new(...)
    end

    extend self
  end
end
