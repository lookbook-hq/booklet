# frozen_string_literal: true

module Booklet
  class SpecNode < EntityNode
    match do |file|
      file.ext?(".rb") && file.name.end_with?("_preview")
    end
  end
end
