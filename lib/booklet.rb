# frozen_string_literal: true

require "literal"
require "active_support"
require "active_support/core_ext"

module Booklet
  Loader = Zeitwerk::Loader.new

  Loader.push_dir("#{__dir__}/booklet", namespace: Booklet)
  Loader.collapse("#{__dir__}/booklet/{content,issues,nodes,visitors,parsers}")
  Loader.collapse("#{__dir__}/booklet/{content,issues,nodes,visitors,parsers}/*")
  Loader.collapse("#{__dir__}/booklet/yard/concerns")
  Loader.ignore("#{__dir__}/booklet/version.rb")
  Loader.inflector.inflect("yard" => "YARD")
  Loader.enable_reloading
  Loader.setup

  Loader.eager_load_dir("#{__dir__}/booklet/nodes") # `Booklet::Node#subclasses`
  Loader.eager_load_dir("#{__dir__}/booklet/yard") # `Booklet::YARD::Tag#subclasses`

  class << self
    delegate :analyze, :update, to: Analyzer

    def version
      Booklet::VERSION
    end

    def loader
      @loader ||= EntityLoader
    end

    def visitors
      @visitors ||= validator_visitors + spec_visitors + page_visitors
    end

    def validator_visitors
      [RubyValidator, HerbValidator]
    end

    def spec_visitors
      [PreviewClassParser, YardTagsHandler, ScenarioGrouper]
    end

    def page_visitors
      [FrontmatterExtractor]
    end

    attr_writer :loader, :visitors, :validator_visitors, :spec_visitors, :page_visitors
  end
end
