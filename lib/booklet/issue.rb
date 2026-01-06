# frozen_string_literal: true

module Booklet
  class Issue < Booklet::Object
    prop :message, String, :positional, reader: :public
    prop :severity, _Nilable(Symbol)
    prop :node, Node, reader: :public
    prop :original_error, _Nilable(_Union(StandardError, Prism::ParseError)), reader: :public

    attr_reader :created_at

    after_initialize do
      @created_at = Time.now
    end

    def severity
      @severity ||= (original_error.present? ? :error : :warning)
    end
  end
end
