require "support/test_helper"
require_relative "shared/locatable_assertions"

module Booklet
  class FileNodeTest < Minitest::Test
    include FixtureHelpers
    include LocatableAssertions

    subject { FileNode }

    context "instance methods" do
      setup do
        @node = subject.from(fixture_file("basic"))
      end

      context ".path" do
        should "return the path as a pathname" do
          assert_equal fixture_file("basic"), @node.path
          assert_kind_of Pathname, @node.path
        end
      end
    end
  end
end
