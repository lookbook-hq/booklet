# frozen_string_literal: true

module Booklet
  class DocumentNode < EntityNode
    match do |file|
      file.ext?(".md", ".md.erb")
    end
  end
end
