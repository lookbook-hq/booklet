# frozen_string_literal: true

require "zeitwerk"
require "literal"
require "active_support"
require "active_support/core_ext"
require "booklet/version"

root = "#{__dir__}/booklet"

loader = Zeitwerk::Loader.new
loader.push_dir(root, namespace: Booklet)
loader.collapse("#{root}/**/*")
loader.ignore("#{root}/version.rb")
loader.inflector.inflect(
  "cli" => "CLI"
)

loader.setup
loader.eager_load_dir("#{root}/nodes") # ensure `Node#subclasses` works as expected

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
