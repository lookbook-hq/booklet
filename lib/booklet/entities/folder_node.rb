# frozen_string_literal: true

module Booklet
  class FolderNode < Node
    include Locatable

    match do |file|
      file.directory?
    end

    permit_child_types Entities.locatable
  end
end
