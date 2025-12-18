# frozen_string_literal: true

module Booklet
  class VSpecParser < Visitor
    node VSpecNode do |spec|
      parse(spec.file, spec)
      spec
    end

    def parse(file, spec)
      raise "VSpecParser subclasses must implement the `#parse` class method"
    end
  end
end
