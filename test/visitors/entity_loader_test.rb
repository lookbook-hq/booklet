require "support/test_helper"

module Booklet
  class FilesystemLoaderTest < Minitest::Test
    context "filesystem loader" do
      setup do
        @root_path = Fixtures.dir("mixed")
        @root = DirectoryNode.from(@root_path)
      end

      should "recursively create entity nodes for all files" do
        @root.accept(EntityLoader.new)

        assert_equal Fixtures.files_within(@root_path).size, @root.descendants.size
      end

      should "not create entities for ignored files" do
        @root.accept(EntityLoader.new(ignore_rules: ["_tmp.*"]))
        ignored_files = Fixtures.files_within(@root_path, grep: /_tmp\./)

        assert_equal(
          Fixtures.files_within(@root_path).size - ignored_files.count,
          @root.descendants.size
        )
      end

      context "branches containing only directories" do
        setup do
          @root_path = Fixtures.dir("empty_dirs")
          @root = DirectoryNode.from(@root_path)
        end

        should "not be included in the tree" do
          @root.accept(EntityLoader)
          nodes = @root.descendants

          assert nodes.find { _1.file.basename == "a" }
          assert nodes.find { _1.file.basename == "aa" }
          assert nodes.find { _1.file.basename == "aaa.txt" }

          refute nodes.find { _1.file.basename == "b" }
          refute nodes.find { _1.file.basename == "bb" }
          refute nodes.find { _1.file.basename == "c" }
        end
      end
    end
  end
end
