# frozen_string_literal: true

module Booklet
  class FolderNode < Node
    include Locatable

    permit_child_types [FolderNode, SpecNode, DocumentNode, AssetNode, AnonNode]

    match do |file|
      file.directory?
    end

    def label
      name.titleize
    end
  end
end
