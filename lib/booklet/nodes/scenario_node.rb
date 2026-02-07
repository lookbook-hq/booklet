module Booklet
  class ScenarioNode < Node
    include Nameable
    include Hideable
    include AcceptsParams
    include AcceptsDisplayOptions

    prop :group, _Nilable(String), reader: :public, writer: :public
    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public
    prop :source, _Nilable(CodeSnippet), reader: :public, writer: :public
    prop :renderer, Proc, :&, writer: :public, default: -> { -> {} }

    def render(view_context = nil, **kwargs)
      params_hash = params.to_values_hash(kwargs)
      @renderer.call(view_context, **params_hash)
    end

    def display_options = Options.new(@display_options)

    alias_method :spec, :parent

    def render_in(view_context)
      params = view_context.try(:request)&.query_parameters || {}
      render(view_context, **params)
    end
  end
end
