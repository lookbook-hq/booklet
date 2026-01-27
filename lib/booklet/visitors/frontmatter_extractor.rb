# frozen_string_literal: true

module Booklet
  class FrontmatterExtractor < Visitor
    after_initialize do
      @parser = FrontmatterParser.new
    end

    visit PageNode do |page|
      return page if page.errors? || visited?(page)

      begin
        frontmatter, contents = @parser.parse_file(page.path)
      rescue => error
        page.add_error(error)
      end

      page.frontmatter = frontmatter
      page.contents = contents

      page
    end
  end
end
