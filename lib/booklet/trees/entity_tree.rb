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
    delegate :path, :to_a, to: :root

    def load!
      @root = files.root.accept(transformer)
      visitors.each { accept(_1) }
      touch!
      self
    end
  end
end
