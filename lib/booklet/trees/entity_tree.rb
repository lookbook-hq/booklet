# frozen_string_literal: true

module Booklet
  class EntityTree < Tree
    prop :files, FileTree, :positional, reader: :public

    prop :transformer, Visitor, reader: :public do |value|
      value.is_a?(Class) ? value.new : value
    end

    prop :visitors, _Array(Visitor), reader: :public do |value|
      value.to_a.map { _1.is_a?(Class) ? _1.new : _1 }
    end

    delegate :loader, to: :files
    delegate :path, to: :@root

    after_initialize do
      @root = files.root.accept(transformer)
      visitors.each { accept(_1) }
      touch!
    end

    def update
      file_tree = files.update

      transformer = @transformer.dup
      transformer.registry = @root.to_a

      self.class.new(file_tree, transformer:, visitors:)
    end
  end
end
