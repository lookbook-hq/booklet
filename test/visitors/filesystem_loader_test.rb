require "support/test_helper"

module Booklet
  class FilesystemLoaderTest < Minitest::Test
    context "filesystem loader" do
      setup do
        @root_path = Fixtures.dir("mixed")
        @root = DirectoryNode.from(@root_path)
      end

      should "recursively create file nodes for all files" do
        @root.accept(FilesystemLoader.new)

        assert_equal Fixtures.files_within(@root_path).size, @root.descendants.size
      end

      should "not load ignored files" do
        @root.accept(FilesystemLoader.new(ignore_rules: ["_tmp.*"]))
        ignored_files = Fixtures.files_within(@root_path, grep: /_tmp\./)

        assert_equal(
          Fixtures.files_within(@root_path).size - ignored_files.count,
          @root.descendants.size
        )
      end
    end
  end
end
