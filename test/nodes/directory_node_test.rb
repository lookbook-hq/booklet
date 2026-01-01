require "support/test_helper"
require_relative "shared/locatable_assertions"

module Booklet
  class DirectoryNodeTest < Minitest::Test
    include FixtureHelpers
    include LocatableAssertions

    subject { DirectoryNode }

    context "instance methods" do
      setup do
        @fixture_file = fixture_file("file_types")
        @node = subject.from(@fixture_file)
      end

      context ".path" do
        should "return the path as a pathname" do
          assert_equal @fixture_file, @node.path
          assert_kind_of Pathname, @node.path
        end
      end

      context ".file?" do
        should "return false" do
          refute @node.file?
        end
      end

      context ".directory?" do
        should "return true" do
          assert @node.directory?
        end
      end
    end
  end
end
