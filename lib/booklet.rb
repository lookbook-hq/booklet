# frozen_string_literal: true

require "zeitwerk"
require "literal"
require "active_support"
require "active_support/core_ext"
require "booklet/version"

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/booklet", namespace: Booklet)
loader.collapse("#{__dir__}/booklet/**/*")
loader.ignore("#{__dir__}/booklet/{version}.rb")
loader.inflector.inflect(
  "cli" => "CLI"
)
loader.setup

module Booklet
  class << self
    def version
      VERSION
    end
  end
end
