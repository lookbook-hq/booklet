# frozen_string_literal: true

module Booklet
  module SpecNode
    extend ActiveSupport::Concern

    included do
      include Locatable

      prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public

      permit_child_types :prose, :scenario

      def label
        name.titleize
      end

      def scenarios
        grep(ScenarioNode)
      end
    end
  end
end
