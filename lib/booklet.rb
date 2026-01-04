# frozen_string_literal: true

require "literal"
require "active_support"
require "active_support/core_ext"
require "booklet/version"
require "booklet/loader"

module Booklet
  class << self
    def version
      VERSION
    end

    def analyze(dir_path, **props)
      analyzer = Analyzer.new(**props)
      analyzer.analyze(dir_path)
    end
  end
end
