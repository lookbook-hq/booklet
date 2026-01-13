# frozen_string_literal: true

module Booklet
  class SpecNode < Node
    include Locatable

    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public

    permit_child_types :prose, :scenario

    match do |file|
      file.basename.end_with?("_preview.rb", "_booklet.rb")
    end

    def format
      if file.basename.end_with?("_preview.rb")
        :preview_class
      elsif file.basename.end_with?("_booklet.rb")
        :booklet_spec
      end
    end

    def label
      name.titleize
    end

    def scenarios
      grep(ScenarioNode)
    end
  end
end
