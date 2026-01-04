# frozen_string_literal: true

require "zeitwerk"

module Booklet
  Loader = Zeitwerk::Loader.new.tap do |loader|
    loader.push_dir(__dir__, namespace: Booklet)
    loader.collapse("#{__dir__}/**/*")
    loader.ignore("#{__dir__}/version.rb")
    loader.inflector.inflect(
      "cli" => "CLI"
    )
    loader.setup
    loader.eager_load_dir("#{__dir__}/nodes") # ensure `Node#subclasses` works as expected
  end
end
