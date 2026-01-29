# frozen_string_literal: true

module Booklet
  module YARD
    class TagSet < Booklet::Object
      prop :tags, _Array(Booklet::YARD::Tag), :positional, default: -> { [] }

      def label
        @tags.grep(Booklet::YARD::LabelTag)&.first
      end
    end
  end
end
