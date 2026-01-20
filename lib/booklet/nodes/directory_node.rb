# frozen_string_literal: true

module Booklet
  class DirectoryNode < Node
    include Locatable

    permit_child_types [DirectoryNode, AssetNode, BookletSpecNode, DocumentNode, PreviewClassNode, SpecNode, FileNode]

    match do |file|
      file.directory?
    end

    def label
      name.titleize
    end

    def name
      file.basename
    end
  end
end
