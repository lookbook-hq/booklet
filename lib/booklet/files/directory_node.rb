# frozen_string_literal: true

module Booklet
  class DirectoryNode < FileNode
    accept_children_of_type FileNode, DirectoryNode
  end
end
