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
        def tag_name(name = nil)
          self.yard_tag_name = name if name

          yard_tag_name
        end

        def identifier
          @identifier = (name.demodulize.delete_suffix("Tag").underscore.downcase.presence || "tag").to_sym
        end

        def label = identifier.to_s.titleize
      end

      class_attribute :yard_tag_name,
        instance_accessor: false,
        instance_predicate: false,
        default: identifier
    end
  end
end
