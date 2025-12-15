require "lookbook-manifest"
require "minitest/autorun"
require "minitest/spec"
require "minitest/hooks/default"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
