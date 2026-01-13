require "support/test_helper"
require_relative "shared/locatable_assertions"

module Booklet
  class FileNodeTest < Minitest::Test
    include LocatableAssertions

    subject { FileNode }

    context "instance methods" do
      setup do
        @fixture_file = Fixtures.file("mixed/overview.md")
        @node = subject.from(@fixture_file)
      end

      context "FileNode#path" do
        should "return the path as a pathname" do
          assert_equal @fixture_file, @node.path
          assert_kind_of Pathname, @node.path
        end
      end

      context "FileNode#file?" do
        should "return true" do
          assert @node.file?
        end
      end

      context "FileNode#directory?" do
        should "return false" do
          refute @node.directory?
        end
      end
    end
  end
end
