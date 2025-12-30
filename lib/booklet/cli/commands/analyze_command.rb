# frozen_string_literal: true

module Booklet
  class AnalyzeCommand < Dry::CLI::Command
    include Colorful

    desc "Analyze a directory of files and display a summary of the results"

    argument :path, required: true, desc: "Root directory path"

    def call(path:, **)
      result = Booklet.analyze(path)

      files = result.files.count
      entities = result.entities.count
      warnings = result.warnings.count
      errors = result.errors.count

      hr = "⎯" * 20

      puts <<~RESULT

        #{hr}

        #{cyan("#{files} #{"file".pluralize(files)}...")}

        #{result.files.accept(AsciiTreeRenderer.new(indent: 1))}

        #{cyan("...converted into #{entities} #{"entity".pluralize(entities)}:")}

        #{result.entities.accept(AsciiTreeRenderer.new(indent: 1))}

        #{hr}

        #{green("Booklet analysis complete", :underline)}

        #{cyan("Root:".ljust(9))} #{path}
        #{cyan(("File".pluralize(files) + ":").ljust(9))} #{files}
        #{cyan(("Entity".pluralize(entities) + ":").ljust(9))} #{entities}
        #{yellow(("Warning".pluralize(warnings) + ":").ljust(9))} #{warnings}
        #{red(("Error".pluralize(errors) + ":").ljust(9))} #{errors}
      RESULT
    end
  end
end
