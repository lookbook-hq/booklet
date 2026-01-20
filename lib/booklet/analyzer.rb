# frozen_string_literal: true

module Booklet
  module Analyzer
    class << self
      def analyze(path, loader: Booklet.loader, transformer: Booklet.transformer, visitors: Booklet.visitors)
        root = Pathname(path).expand_path
        file_tree = FileTree.new(root, loader:)

        EntityTree.new(file_tree, transformer:, visitors:)
      end
    end
  end
end
