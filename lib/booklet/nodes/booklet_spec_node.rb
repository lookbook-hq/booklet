# frozen_string_literal: true

module Booklet
  class BookletSpecNode < SpecNode
    include Locatable

    match do |file|
      file.basename.end_with?("_booklet.rb")
    end
  end
end
