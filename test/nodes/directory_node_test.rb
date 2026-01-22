require "support/test_helper"
require_relative "shared/locatable_assertions"

module Booklet
  class FolderNodeTest < Minitest::Test
    # include LocatableAssertions

    subject { FolderNode }

    context "instance methods" do
      setup do
        @fixture_file = Fixtures.file("mixed")
        @node = subject.from(@fixture_file)
      end

      context "FolderNode#path" do
        should "return the path as a pathname" do
          assert_equal @fixture_file, @node.path
          assert_kind_of Pathname, @node.path
        end
      end

      context "FolderNode#file?" do
        should "return false" do
          refute @node.file?
        end
      end

      context "FolderNode#directory?" do
        should "return true" do
          assert @node.directory?
        end
      end
    end
  end
end
