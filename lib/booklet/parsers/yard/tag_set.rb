# frozen_string_literal: true

module Booklet
  module YARD
    class TagSet < Booklet::Object
      prop :tags, _Array(Tag), :positional, default: -> { [] } do |array|
        array.grep(Tag)
      end

      def label
        @tags.grep(LabelTag)&.first
      end

      def hidden?
        @tags.grep(HiddenTag)&.first&.value || false
      end
    end
  end
end
