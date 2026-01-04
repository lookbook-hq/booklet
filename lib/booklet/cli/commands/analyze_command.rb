# frozen_string_literal: true

module Booklet
  class AnalyzeCommand < Dry::CLI::Command
    include Colorful

    desc "Analyze a directory of files and display a summary of the results"

    argument :path, required: true, desc: "Root directory path"

    def call(path:, **)
      result = Booklet.analyze(path)

      files = result.files
      entities = result.entities
      warnings = result.warnings
      errors = result.errors

      hr = "⎯" * 20

      puts <<~SUMMARY

        #{green("Booklet analysis complete", :underline)}

        #{cyan("Root:".ljust(9))} #{path}
        #{cyan("Files:".ljust(9))} #{files.count}
        #{cyan("Entities:".ljust(9))} #{entities.count}
      SUMMARY

      if result.issues.any?
        puts

        if errors.any?
          messages = errors.map do |issue|
            file = issue.node.file
            "* [#{file.relative_path(result.path)}] #{issue.message}"
          end

          puts <<~ERRORS
            #{red("Errors (#{errors.count})")}
            #{messages.join("\n")}
          ERRORS

          puts if warnings.any?
        end

        if warnings.any?
          messages = warnings.map do |issue|
            file = issue.node.file
            "* [#{file.relative_path(result.path)}] #{issue.message}"
          end

          puts <<~WARNINGS
            #{yellow("Warnings (#{warnings.count})")}
            #{messages.join("\n")}
          WARNINGS
        end
      end
    end
  end
end
