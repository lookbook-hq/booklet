# frozen_string_literal: true

module Booklet
  class FrontmatterParser < Booklet::Object
    FRONTMATTER_REGEX = /\A---(.|\n)*?---/

    def parse_file(path)
      contents = File.read(path)
      [
        FrontmatterParser.extract_frontmatter(contents),
        FrontmatterParser.strip_frontmatter(contents)
      ]
    end

    class << self
      def extract_frontmatter(text)
        matches = text.match(FRONTMATTER_REGEX)
        matches ? YAML.safe_load(matches[0]).deep_symbolize_keys : {}
      end

      def strip_frontmatter(text)
        text.gsub(FRONTMATTER_REGEX, "").strip
      end
    end
  end
end
