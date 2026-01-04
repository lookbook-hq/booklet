# frozen_string_literal: true

require "dry/cli"

module Booklet
  module CLI
    extend Dry::CLI::Registry

    register "version", VersionCommand, aliases: ["v", "-v", "--version"]
    register "analyze", AnalyzeCommand

    def self.call
      Dry::CLI.new(self).call
    end
  end
end
