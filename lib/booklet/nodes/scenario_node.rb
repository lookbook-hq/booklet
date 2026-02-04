module Booklet
  class ScenarioNode < Node
    include Nameable
    include Hideable
    include AcceptsParams
    include AcceptsDisplayOptions

    prop :group, _Nilable(String), reader: :public, writer: :public
    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public
    prop :source, _Nilable(CodeSnippet), reader: :public, writer: :public
    prop :context, _Nilable(::Object), reader: :public, writer: :public

    # prop :callable, Proc, :&, writer: :public

    def display_options
      Options.new(@display_options)
    end

    alias_method :spec, :parent
  end
end
