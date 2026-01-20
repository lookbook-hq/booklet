# frozen_string_literal: true

module Booklet
  class FileTree < Tree
    prop :path, Pathname, :positional, reader: :public
    prop :loader, _Union(Visitor, _Class(Visitor)), reader: :public

    after_initialize do
      @root = DirectoryNode.from(@path).accept(@loader)
      touch!
    end

    def update
      self.class.new(path, loader:)
    end
  end
end
