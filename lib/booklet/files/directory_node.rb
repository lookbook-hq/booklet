# frozen_string_literal: true

module Booklet
  class DirectoryNode < FileNode
    match do |file|
      file.directory?
    end

    permit_child_types FileNode, DirectoryNode
  end
end
