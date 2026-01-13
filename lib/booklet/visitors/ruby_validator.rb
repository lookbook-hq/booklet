# frozen_string_literal: true

require "prism"

module Booklet
  class RubyValidator < Visitor
    visit FolderNode, DirectoryNode do |node|
      visit_each(node.children)
      node
    end

    visit do |node|
      if node.file&.ext?(".rb")
        parse_result = Prism.parse_file(node.file.path.to_s)
        parse_result.errors.each do |error|
          node.add_error(error)
        end
      end
      node
    end
  end
end
