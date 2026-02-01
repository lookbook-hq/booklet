# frozen_string_literal: true

module Booklet
  module YARD
    class TagOptions < Booklet::Object
      prop :raw, String, :positional

      def resolve(context)
        # ....
      end
    end
  end
end
