# frozen_string_literal: true

require "paint"

module Booklet
  module Colorful
    extend ActiveSupport::Concern

    included do
      def pink(str, *)
        paint(str, "#FF1493", *)
      end

      def cyan(str, *)
        paint(str, :cyan, *)
      end

      def magenta(str, *)
        paint(str, :cyan, *)
      end

      def gray(str, *)
        paint(str, :gray, *)
      end

      def green(str, *)
        paint(str, :green, *)
      end

      def orange(str, *)
        paint(str, "#FFA500", *)
      end

      def yellow(str, *)
        paint(str, "#DAA520", *)
      end

      def gold(str, *)
        paint(str, "#DAA520", *)
      end

      def red(str, *)
        paint(str, :red, *)
      end

      def paint(*)
        Paint[*]
      end
    end
  end
end
