module Booklet
  module Locatable
    extend ActiveSupport::Concern

    included do
      class_attribute :file_matcher,
        instance_reader: false,
        instance_writer: false,
        instance_predicate: false,
        default: proc { false }

      prop :file, File, reader: :public

      attr_reader :ctime

      after_initialize do |node|
        @ctime = node.file.ctime
      rescue Errno::ENOENT
        # Do nothing
      end

      delegate :name, :path, :directory?, :file?, to: :file

      def dirty?
        @ctime.before?(file.ctime)
      end

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

      def match(&block)
        self.file_matcher = block
      end

      def from?(file)
        file_matcher.call(file)
      end

      def locatable?
        true
      end
    end
  end
end
