# frozen_string_literal: true

module Booklet
  class FolderNode < EntityNode
    match do |file|
      file.directory?
    end

    permit_child_types EntityNode.types
  end
end
