require "support/test_helper"

module Booklet
  class FilesystemLoaderTest < Minitest::Test
    include FixtureHelpers

    context "filesystem loader" do
      setup do
        @root_path = fixture_file("basic")
        @root = DirectoryNode.from(@root_path)
      end

      should "recursively create file nodes for all files" do
        @root.accept(FilesystemLoader.new)

        assert_equal fixtures_within(@root_path).size, @root.descendants.size
      end

      should "not load ignored files" do
        @root.accept(FilesystemLoader.new(ignore_rules: ["ignore_me.*"]))
        assert_equal fixtures_within(@root_path).size - 1, @root.descendants.size
      end
    end
  end
end
