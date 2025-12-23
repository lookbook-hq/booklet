module Booklet
  module Commands
    extend Dry::CLI::Registry

    register "version", VersionCommand, aliases: ["v", "-v", "--version"]
    register "analyze", AnalyzeCommand
  end
end
