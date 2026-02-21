# frozen_string_literal: true

require "active_support/ordered_options"
require "commonmarker"

module Booklet
  class PageNode < Node
    include Locatable
    include Nameable
    include Hideable

    EXTENSIONS = [".md", ".md.erb"]

    prop :contents, _String?, writer: :public
    prop :data, _Nilable(Options), reader: :public do
      Options.new(_1)
    end

    prop :footer, _Boolean?, writer: :public, default: false
    prop :header, _Boolean?, writer: :public, default: false
    prop :landing, _Boolean?, writer: :public, default: false

    prop :ast, _Nilable(_Union(Commonmarker::Node, Proc)), writer: :public

    def data=(value)
      @data = Options.new(value)
    end

    def contents
      @contents ||= File.read(path)
    end

    def hidden? = @hidden

    def footer? = @footer

    def header? = @header

    def landing? = @landing

    def ast
      case @ast
      when Commonmarker::Node
        @ast
      when Proc
        @ast = @ast.call
      else
        @ast
      end
    end

    def to_html(...) = ast&.to_html(...)

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
