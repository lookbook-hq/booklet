module Booklet
  class AnonymousNode < EntityNode
    class << self
      def from(file)
        new(file.name, file:)
      end

      def match?(file)
        true
      end
    end
  end
end
