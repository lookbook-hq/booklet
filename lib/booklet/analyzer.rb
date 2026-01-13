# frozen_string_literal: true

module Booklet
  module Analyzer
    class << self
      def analyze(path, loader: Booklet.loader, transformer: Booklet.transformer, visitors: Booklet.visitors)
        root = Pathname(path).expand_path
        files = DirectoryNode.from(root).accept(loader)

        Tree.from(files, transformer, visitors:)
      end
    end
  end
end
