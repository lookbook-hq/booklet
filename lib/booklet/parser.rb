# frozen_string_literal: true

module Booklet
  class Parser < Booklet::Object
    DEFAULT_FILE_VISITORS = []
    DEFAULT_ENTITY_VISITORS = [
      PreviewClassParser
    ]

    prop :loader, Visitor, default: -> { FilesystemLoader.new }
    prop :after_load, _Array(Visitor), reader: :public, default: -> { DEFAULT_FILE_VISITORS.map(&:new) }

    prop :transformer, Visitor, default: -> { EntityTransformer.new }
    prop :after_transform, _Array(Visitor), reader: :public, default: -> { DEFAULT_ENTITY_VISITORS.map(&:new) }

    def parse(path)
      path = Pathname(path.to_s).expand_path unless path.nil?
      files = DirectoryNode.new(path.basename, path:).accept(@loader)
      @after_load.each { files.accept(_1) }

      entities = files.accept(@transformer)
      @after_transform.each { entities.accept(_1) }

      ParserResult.new(path:, files:, entities:)
    end
  end
end
