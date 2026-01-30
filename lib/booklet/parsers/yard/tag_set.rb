# frozen_string_literal: true

module Booklet
  module YARD
    class TagSet < Booklet::Object
      prop :tags, _Array(Tag), :positional, default: -> { [] } do |array|
        array.grep(Tag)
      end

      def label
        label_tag&.value
      end

      def hidden?
        hidden_tag&.value || false
      end

      def display_options
        pairs = display_option_tags.map { [_1.key, _1.value] }
        pairs.to_h.deep_symbolize_keys!
      end

      def label_tag
        @tags.grep(LabelTag)&.first
      end

      def hidden_tag
        @tags.grep(HiddenTag)&.first
      end

      def display_option_tags
        Options.from(@tags.grep(DisplayTag))
      end
    end
  end
end
