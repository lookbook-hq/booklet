# frozen_string_literal: true

module Booklet
  class AnalyzerResult < Value
    prop :path, Pathname
    prop :files, DirectoryNode
    prop :entities, FolderNode
    prop :issues, IssueLog, default: IssueLog.new.freeze
  end
end
