# frozen_string_literal: true

module Booklet
  class Analyzer < Booklet::Object
    DEFAULT_FILE_VISITORS = []
    DEFAULT_ENTITY_VISITORS = [
      RubyValidator,
      PreviewClassParser,
      FrontmatterExtractor
    ]

    prop :loader, Visitor, default: -> { FilesystemLoader.new }
    prop :after_load, _Array(Visitor), reader: :public, default: -> { DEFAULT_FILE_VISITORS.map(&:new) }

    prop :transformer, Visitor, default: -> { EntityTransformer.new }
    prop :after_transform, _Array(Visitor), reader: :public, default: -> { DEFAULT_ENTITY_VISITORS.map(&:new) }

    def analyze(path)
      path = Pathname(path.to_s).expand_path unless path.nil?
      files = DirectoryNode.from(path).accept(@loader)
      @after_load.each { files.accept(_1) }

      entities = files.accept(@transformer)
      @after_transform.each { entities.accept(_1) }

      issues = entities.accept(IssueAggregator.new)

      AnalyzerResult.new(path:, files:, entities:, issues:)
    end
  end

  class AnalyzerResult < Value
    prop :path, Pathname
    prop :files, DirectoryNode
    prop :entities, FolderNode
    prop :issues, IssueLog, default: IssueLog.new.freeze

    delegate :warnings, :errors, :warnings?, :errors?, to: :issues
  end
end
