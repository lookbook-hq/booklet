# frozen_string_literal: true

module Booklet
  class IssueLog < Booklet::Object
    include Enumerable

    prop :issues, _Array(Issue), :positional, default: -> { [] }

    def add(*issues)
      @issues.push(*issues.flatten)
      self
    end

    def warnings
      all.select { _1.is_a?(Warning) }
    end

    def warnings?
      warnings.any?
    end

    def errors
      all.select { _1.is_a?(Error) }
    end

    def errors?
      errors.any?
    end

    def all
      @issues
    end

    def clear
      @issues.clear
      self
    end

    delegate :each, :to_a, to: :@issues
  end
end
