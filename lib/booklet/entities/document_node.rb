# frozen_string_literal: true

module Booklet
  class DocumentNode < Node
    include Locatable

    match do |file|
      file.ext?(".md", ".md.erb")
    end
  end
end
