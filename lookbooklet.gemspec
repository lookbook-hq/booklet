# frozen_string_literal: true

require_relative "lib/booklet/version"

Gem::Specification.new do |spec|
  spec.name = "lookbooklet"
  spec.version = Booklet::VERSION
  spec.authors = ["Mark Perkins"]
  spec.homepage = "https://github.com/lookbook-hq/booklet"
  spec.summary = "An experimental new parser engine for Lookbook"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*", "bin/booklet", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]
  spec.executables << "booklet"

  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "activesupport", ">= 7.2"
  spec.add_dependency "dry-cli", "~> 1.1"
  spec.add_dependency "literal", "~> 1.8"
  spec.add_dependency "marcel", ">= 1.0"
  spec.add_dependency "paint", "~> 2.3"
  spec.add_dependency "yard", "~> 0.9"
  spec.add_dependency "zeitwerk", "~> 2.7"
end
