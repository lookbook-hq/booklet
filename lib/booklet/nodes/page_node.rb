# frozen_string_literal: true

require "active_support/ordered_options"

module Booklet
  class PageNode < Node
    include Locatable
    include Nameable

    EXTENSIONS = [".md", ".md.erb"]

    prop :frontmatter, _Nilable(Hash), writer: :public

    prop :contents, _Nilable(String), writer: :public

    def frontmatter
      return @frontmatter if @frontmatter.is_a?(ActiveSupport::InheritableOptions)

      @frontmatter = ActiveSupport::InheritableOptions.new(@frontmatter.to_h)
    end

    def contents
      @contents ||= File.read(path)
    end

    class << self
      def from(path, **props)
        unless FileHelpers.extension(path).in?(EXTENSIONS)
          raise ArgumentError, "#{path} is not a PageNode"
        end

        path = Pathname(path)
        name = FileHelpers.file_name(path)

        new(path, name:, **props)
      end
    end
  end
end
