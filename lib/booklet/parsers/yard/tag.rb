# frozen_string_literal: true

require "yard/tags/tag"

module Booklet
  module YARD
    class Tag < ::YARD::Tags::Tag
      def options_str
        @options || ""
      end

      class << self
        def identifier
          @name ||= name.demodulize.delete_suffix("Tag").underscore.downcase.presence || "tag"
        end

        def label = name.titleize
      end
    end
  end
end
