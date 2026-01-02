# frozen_string_literal: true

module Booklet
  class Issues < Booklet::Object
    include Enumerable

    prop :issue_list, _Array(Issue), :positional, default: -> { [] }

    def add(*issues)
      @issue_list.push(*issues.flatten.map(&:to_a).flatten)
      self
    end

    def add_warning(...)
      @issue_list << Issues.warning(...)
      self
    end

    def warnings
      all.select { _1.severity == :warning }
    end

    def warnings?
      warnings.any?
    end

    def add_error(...)
      @issue_list << Issues.error(...)
      self
    end

    def errors
      all.select { _1.severity == :error }
    end

    def errors?
      errors.any?
    end

    def all
      @issue_list.sort { _1.created_at }
    end

    def clear
      @errors.clear
      @warnings.clear
    end

    def to_a
      @issue_list
    end

    delegate :each, to: :@issue_list

    class << self
      def warning(*, **)
        Issue.new(*, **, severity: :warning)
      end

      def error(*, **)
        Issue.new(*, **, severity: :error)
      end
    end
  end
end
