require "support/test_helper"

module Booklet
  class FileNodeTest < Minitest::Test
    include FixtureHelpers

    context "class methods" do
      context ".new" do
        should "succeed when instatiated with a <String> name and a <Pathname> for the path kwarg" do
          assert_kind_of FileNode, FileNode.new("foxes", path: Pathname("the.foxes-4b.png"))
        end

        should "raise an argument error if an name is not provided" do
          assert_raises(ArgumentError) { FileNode.new(path: Pathname("the.foxes-4b.png")) }
        end

        should "raise an argument error if a path is not provided" do
          assert_raises(ArgumentError) { FileNode.new("foxes") }
        end

        should "raise a type error if the path is not a Pathname" do
          assert_raises(TypeError) { FileNode.new("foxes", path: "the.foxes-4b.png") }
        end
      end
    end

    context "instance methods" do
      setup do
        @node = FileNode.new("root", path: fixture_file("basic"))
      end

      context ".path" do
        should "return the path as a pathname" do
          assert_equal fixture_file("basic"), @node.path
          assert_kind_of Pathname, @node.path
        end
      end

      context ".file" do
        should "returns a Booklet::File object instance" do
          assert_kind_of Booklet::File, @node.file
          assert_equal fixture_file("basic"), @node.file.path
        end
      end

      context ".file?" do
        should "returns true" do
          assert @node.file?
        end
      end
    end
  end
end
