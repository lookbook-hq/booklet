# frozen_string_literal: true

module Booklet
  class MethodSnippet < CodeSnippet
    prop :name, String, reader: :public

    def body
      extract_method_body(raw)
    end

    alias_method :value, :body
    alias_method :to_s, :body

    protected def extract_method_body(source)
      source = source.strip_heredoc
      output = source.sub(/^def \w+\s?(\([^)]+\))?/m, "").split("\n")[0..-2].join("\n")
      output.strip_heredoc
    end

    class << self
      def from_code_object(code_object)
        MethodSnippet.new(
          code_object.source,
          name: code_object.path,
          lang: code_object.source_type,
          location: [code_object.file, code_object.line]
        )
      end
    end
  end
end
