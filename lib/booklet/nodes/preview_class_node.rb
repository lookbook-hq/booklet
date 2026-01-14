# frozen_string_literal: true

module Booklet
  class PreviewClassNode < Node
    include SpecNode

    match do |file|
      file.basename.end_with?("_preview.rb")
    end
  end
end
