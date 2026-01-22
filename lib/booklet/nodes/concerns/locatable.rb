module Booklet
  module Locatable
    extend ActiveSupport::Concern

    included do
      attr_reader :ctime

      prop :path, Pathname, reader: :public do |value|
        Pathname(value.to_s) unless value.nil?
      end

      after_initialize do |node|
        @ctime = path.ctime
      rescue Errno::ENOENT
        # Do nothing
      end

      def dirty?
        @ctime.before?(path.ctime)
      end

      def locatable?
        true
      end
    end

    class_methods do
      def from(path)
        new(path, path:)
      end
    end
  end
end
