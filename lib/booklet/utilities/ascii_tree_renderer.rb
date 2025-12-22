# frozen_string_literal: true

module Booklet
  class AsciiTreeRenderer < Visitor
    PIPE = "│"
    BRANCH = "├──"
    LEAF = "└──"
    SPACE = " "

    after_initialize do
      @lines = []
      @prefix = +""
    end

    visit do |node|
      memo = @prefix

      if node.root?
        @lines << node.name
      else
        @lines << @prefix + (node.last_sibling? ? LEAF : BRANCH) + SPACE + node.name
        @prefix += (node.last_sibling? ? SPACE : PIPE) + (SPACE * BRANCH.size)
      end

      visit_each(node.children)
      @prefix = memo

      @lines.join("\n")
    end
  end
end
