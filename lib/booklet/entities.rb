# frozen_string_literal: true

module Booklet
  module Entities
    def self.locatable
      [FolderNode, SpecNode, DocumentNode, AssetNode, AnonNode]
    end
  end
end
