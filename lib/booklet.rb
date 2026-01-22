# frozen_string_literal: true

require "literal"
require "active_support"
require "active_support/core_ext"

loader = Zeitwerk::Loader.new

loader.push_dir("#{__dir__}/booklet", namespace: Booklet)
loader.collapse("#{__dir__}/booklet/**/*")
loader.ignore("#{__dir__}/booklet/version.rb")

loader.setup
loader.eager_load_dir("#{__dir__}/booklet/nodes") # ensure `Booklet::Node#subclasses` works as expected

module Booklet
  class << self
    delegate :analyze, :update, to: Analyzer

    def version
      Booklet::VERSION
    end

    def loader
      @loader ||= EntityLoader
    end

    def visitors
      @visitors ||= [
        RubyValidator,
        HerbValidator,
        PreviewClassParser,
        FrontmatterExtractor
      ]
    end

    attr_writer :loader, :visitors
  end
end
