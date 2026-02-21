# frozen_string_literal: true

require "commonmarker"

module Booklet
  class MarkdownParser < FileVisitor
    prop :options, Hash, default: -> { {} }

    visit PageNode do |page|
      return page if visited?(page)

      page.ast = -> { Commonmarker.parse(page.contents, options: @options) }
      page
    end
  end
end
