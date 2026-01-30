# frozen_string_literal: true

module Booklet
  module YARD
    class TagSet < Booklet::Object
      include Enumerable

      prop :tags, _Array(Tag), :positional, default: -> { [] } do |array|
        array.grep(Tag)
      end

      delegate :each, to: :@tags

      def names
        map(&:identifier).uniq
      end

      def label_tag
        grep(LabelTag)&.first
      end

      def hidden_tag
        grep(HiddenTag)&.first
      end

      def display_tags
        Options.from(grep(DisplayTag))
      end
    end
  end
end
