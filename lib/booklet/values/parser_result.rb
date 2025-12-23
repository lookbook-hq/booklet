# frozen_string_literal: true

module Booklet
  class ParserResult < Value
    prop :path, Pathname
    prop :files, DirectoryNode
    prop :entities, FolderNode
    prop :warnings, Array, default: [].freeze
    prop :errors, Array, default: [].freeze
  end
end
