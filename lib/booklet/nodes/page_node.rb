# frozen_string_literal: true

module Booklet
  class PageNode < Node
    include Locatable
    include Nameable

    EXTENSIONS = [".md", ".md.erb"]

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
