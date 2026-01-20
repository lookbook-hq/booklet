# frozen_string_literal: true

module Booklet
  class FileTree < Tree
    prop :path, Pathname, :positional, reader: :public
    prop :loader, _Union(Visitor, _Class(Visitor)), reader: :public

    def load!
      @root = DirectoryNode.from(@path).accept(@loader)
      touch!
    end
  end
end
