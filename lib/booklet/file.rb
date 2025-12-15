require "marcel"

module Booklet
  class File < Booklet::Object
    include Callbackable

    prop :path, Pathname, :positional, reader: false do |value|
      Pathname(value) unless value.nil?
    end

    after_initialize do
      raise ArgumentError, "File paths must be absolute" unless @path.absolute?
    end

    def path(strip_extension: false)
      strip_extension ? Pathname(@path.to_s.delete_suffix(ext)) : @path
    end

    def relative_path(root = Dir.pwd, strip_extension: false)
      path(strip_extension).relative_path_from(root)
    end

    def relative_path_segments
      relative_path.to_s.split("/")
    end

    def ext
      basename.to_s.gsub(/^([^.]+)/, "") if file?
    end

    def ext?(*extensions)
      extensions.any? { ".#{_1.to_s.delete_prefix(".")}" == ext }
    end

    def name
      (file? ? basename(ext) : basename).to_s
    end

    def basename(*)
      path.basename(*).to_s
    end

    def mime_type
      Marcel::MimeType.for(path, name: basename) if file?
    end

    def mtime
      ::File.mtime(path)
    end

    def contents
      raise "Cannot read contents of a directory" unless file?

      ::File.read(path)
    end

    def parent_directory_of?(child_path)
      return false if file?

      self.class.new(child_path).dirname == path
    end

    def anscestor_directory_of?(descendant_path)
      return false if file?

      self.class.new(descendant_path).path.to_s.start_with?("#{path}/")
    end

    def to_h
      {path:, basename:, name:, ext:, directory: directory?, file: file?}.compact
    end

    def to_s
      path.to_s
    end

    alias_method :value, :path
    alias_method :to_pathname, :path

    delegate_missing_to :path

    class << self
      def file?(file)
        file.is_a?(File)
      end
    end
  end
end
