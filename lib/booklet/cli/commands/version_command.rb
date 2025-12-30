# frozen_string_literal: true

module Booklet
  class VersionCommand < Dry::CLI::Command
    include Colorful

    desc "Print version"

    def call(*)
      puts "#{pink("booklet")} v#{VERSION}"
    end
  end
end
