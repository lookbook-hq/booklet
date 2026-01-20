# frozen_string_literal: true

module Booklet
  module Analyzer
    class << self
      def analyze(path, loader: Booklet.loader, transformer: Booklet.transformer, visitors: Booklet.visitors)
        root = Pathname(path).expand_path
        files = FileTree.new(root, loader:)

        EntityTree.new(files, transformer:, visitors:).load!
      end

      def update(tree)
        files = FileTree.new(tree.path, loader: tree.loader)

        transformer = tree.transformer.dup
        transformer.registry = tree.to_a

        EntityTree.new(files, transformer:, visitors: tree.visitors).load!
      end
    end
  end
end
