require "lookbooklet"
require "minitest/autorun"
require "shoulda"
require "minitest/reporters"

require_relative "fixture_helpers"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
