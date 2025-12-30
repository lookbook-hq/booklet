# frozen_string_literal: true

module Booklet
  class DirectoryNode < Node
    include Locatable

    permit_child_types FileNode, DirectoryNode

    def name
      file.basename
    end

    alias_method :label, :name

    delegate :file?, :directory?, :ext, :ext?, :dirname, :basename, :path_segments, :mime_type, :to_pathname, :contents, to: :file
  end
end
