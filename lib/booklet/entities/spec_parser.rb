# frozen_string_literal: true

module Booklet
  class SpecParser < Visitor
    visit SpecNode do |spec|
      parse(spec.file, spec)
      spec
    end

    def parse(file, spec)
      raise "SpecParser subclasses must implement the `#parse` class method"
    end
  end
end
