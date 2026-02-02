module Booklet
  class ScenarioNode < Node
    include Nameable
    include Hideable
    include AcceptsParams
    include AcceptsDisplayOptions

    prop :group, _Nilable(String), reader: :public, writer: :public
    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public
    prop :source, _Nilable(CodeSnippet), reader: :public, writer: :public
    prop :context_path, _Nilable(String), writer: :public

    def context
      @context_path.constantize.new
    end

    def display_options
      Options.new(@display_options)
    end

    def lookup_value = name

    alias_method :spec, :parent
  end
end
