require "lookbooklet"
require "minitest/autorun"
require "shoulda-context"

require "pretty_please"
require "pd"

require_relative "fixture_helpers"

PutsDebuggerer.header = "-" * 80
PutsDebuggerer.print_engine = lambda do |object|
  output = case object
  when String
    object
  else
    PrettyPlease.prettify(object)
  end
  puts output
end
