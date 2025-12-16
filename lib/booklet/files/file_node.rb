# frozen_string_literal: true

module Booklet
  class FileNode < Node
    prop :path, Pathname, reader: :public, writer: false

    def file
      @file ||= File.new(path)
    end

    delegate :file?, :directory?, :ext, :ext?, :dirname, :basename, :path_segments, :mime_type, :to_pathname, :contents, to: :file
  end
end
