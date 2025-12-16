require "support/test_helper"

module Booklet
  class EntityTransformerTest < Minitest::Test
    include FixtureHelpers

    context "visiting a directory" do
      setup do
        @root_path = fixture_file("basic")
        @files = DirectoryNode.new("root", path: @root_path).accept(FilesystemLoader.new)
      end

      should "transform all nodes to entity nodes" do
        entities = @files.accept(EntityTransformer.new)

        entities.each do |node|
          assert_kind_of EntityNode, node
        end

        assert_equal fixture_dir_descendant_count(@root_path), @files.descendants.size
      end

      should "not mutate the file tree" do
        @files.accept(EntityTransformer.new)

        @files.each do |node|
          assert_kind_of FileNode, node
        end
      end
    end
  end
end
