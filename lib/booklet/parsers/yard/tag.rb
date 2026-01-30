# frozen_string_literal: true

require "yard/tags/tag"

module Booklet
  module YARD
    class Tag < ::YARD::Tags::Tag
      def options_str
        @options || ""
      end

      def identifier
        self.class.identifier
      end

      class << self
        def identifier
          @name ||= (name.demodulize.delete_suffix("Tag").underscore.downcase.presence || "tag").to_sym
        end

        def label = name.titleize
      end
    end
  end
end
