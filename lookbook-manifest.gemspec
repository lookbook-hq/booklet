# frozen_string_literal: true

require_relative "lib/lookbook/manifest/version"

Gem::Specification.new do |spec|
  spec.name = "lookbook-manifest"
  spec.version = Lookbook::Manifest::VERSION
  spec.authors = ["Mark Perkins"]
  spec.homepage = "https://github.com/lookbook-hq/manifest"
  spec.summary = "Experimental file parser & entity tree generator for Lookbook"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "activesupport", ">= 7.2"
  spec.add_dependency "literal", "~> 1.8"
  spec.add_dependency "zeitwerk", "~> 2.7"
end
