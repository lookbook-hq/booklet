module Booklet
  module Locatable
    extend ActiveSupport::Concern

    included do
      prop :file, File, reader: :public, writer: false

      delegate :name, to: :file

      def label
        name.titleize
      end
    end

    class_methods do
      def from(file)
        new(file.path, file:)
      end
    end
  end
end
