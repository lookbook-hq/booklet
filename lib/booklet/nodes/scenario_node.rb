module Booklet
  class ScenarioNode < Node
    include Nameable

    prop :notes, _Nilable(TextSnippet), reader: :public, writer: :public
    prop :source, CodeSnippet, reader: :public
    prop :parameters, Array, reader: :public, writer: :public, default: -> { [] }
    prop :tags, YARD::TagSet, default: -> { YARD::TagSet.new } do |tags|
      YARD::TagSet.new(tags.to_a.grep(YARD::Tag))
    end

    def lookup_value
      name
    end
  end
end
