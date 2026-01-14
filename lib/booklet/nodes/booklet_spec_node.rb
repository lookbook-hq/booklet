# frozen_string_literal: true

module Booklet
  class BookletSpecNode < Node
    include SpecNode

    match do |file|
      file.basename.end_with?("_booklet.rb")
    end
  end
end
