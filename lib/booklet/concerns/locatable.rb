module Booklet
  module Locatable
    extend ActiveSupport::Concern

    included do
      prop :file, File, reader: :public, writer: false

      delegate :name, :path, to: :file
    end

    class_methods do
      def from(file_or_path)
        file = file_or_path.is_a?(File) ? file_or_path : File.new(file_or_path)
        new(file.path, file:)
      end
    end
  end
end
