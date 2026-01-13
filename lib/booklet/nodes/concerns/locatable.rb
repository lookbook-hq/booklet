module Booklet
  module Locatable
    extend ActiveSupport::Concern

    included do
      prop :file, File, reader: :public

      delegate :name, :path, to: :file

      def locatable?
        true
      end
    end

    class_methods do
      def from(source)
        file = case source
        when File
          source.dup
        when Pathname, String
          File.new(source)
        else
          raise ArgumentError, "Expected Pathname, String or Booklet::File instance - #{source.class.name} given"
        end

        new(file.path, file:)
      end

      def locatable?
        true
      end
    end
  end
end
