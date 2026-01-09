# frozen_string_literal: true

module Booklet
  class IssueAggregator < Visitor
    visit do |node|
      @issues ||= IssueLog.new
      @issues.add(*node.issues)

      visit_each(node.children)
      node.root? ? @issues : node
    end
  end
end
