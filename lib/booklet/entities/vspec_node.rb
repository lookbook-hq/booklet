# frozen_string_literal: true

module Booklet
  class VSpecNode < EntityNode
    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public

    permit_child_types :prose, :scenario

    match do |file|
      file.ext?(".rb") && file.name.end_with?("_preview")
    end

    def scenarios
      filter(&:scenario?)
    end
  end
end
