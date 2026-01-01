require "support/test_helper"

module Booklet
  class EntityTransformerTest < Minitest::Test
    include FixtureHelpers

    context "entity transformer" do
      setup do
        @root_path = fixture_file("entities")
        @root_dir = DirectoryNode.from(@root_path)
        @files = @root_dir.accept(FilesystemLoader.new)
      end

      context "when visiting a tree of file nodes" do
        should "transform all nodes to file entity nodes" do
          entities = @files.accept(EntityTransformer.new)
          entities.each_node do |node|
            assert node.class.in?(Node.locatable_entity_node_types)
          end

          assert_equal fixtures_within(@root_path).size, entities.descendants.size
        end

        should "not mutate the original file tree" do
          @files.accept(EntityTransformer.new)

          assert @files == @root_dir

          @files.each_node do |node|
            assert node.class.in?(Node.file_node_types)
          end
        end
      end

      context "file to entity conversion" do
        setup do
          @entities = @files.accept(EntityTransformer.new)
        end

        context "FolderNode" do
          should "be instantiated for each directory node" do
            dirs = fixtures_within(@root_path).filter(&:directory?)
            assert dirs.size > 0

            dirs.each do |path|
              assert_kind_of FolderNode, @entities.find { _1.file.path == path }
            end
          end
        end

        context "SpecNode" do
          should "be instantiated for each valid preview class file" do
            preview_classes = fixtures_within(@root_path).filter { _1.to_s.end_with?("_preview.rb") }

            assert preview_classes.size
            assert_equal preview_classes.size, @entities.count(&:spec?)

            preview_classes.each do |path|
              spec = @entities.find { _1.file.path == path }
              assert_kind_of SpecNode, spec
              assert spec.spec?
            end
          end
        end

        context "DocumentNode" do
          should "be instantiated for each matching markdown file" do
            doc_files = markdown_fixtures_within(@root_path)
            assert doc_files.size
            assert_equal doc_files.size, @entities.count(&:document?)

            doc_files.each do |path|
              doc = @entities.find { _1.file.path == path }
              assert_kind_of DocumentNode, doc
              assert doc.document?
            end
          end
        end

        context "AssetNode" do
          should "be instantiated from each css, js and image file" do
            asset_files = asset_fixtures_within(@root_path)
            assert asset_files.size
            assert_equal asset_files.size, @entities.count(&:asset?)

            asset_files.each do |path|
              asset = @entities.find { _1.file.path == path }
              assert_kind_of AssetNode, asset
              assert asset.asset?
            end
          end
        end

        context "AnonNode" do
          should "be created from any files that cannot otherwise be matched to a specific entity type" do
            unrecognised_files = anon_fixtures_within(@root_path)
            assert unrecognised_files.size
            assert_equal unrecognised_files.size, @entities.count(&:anon?)

            unrecognised_files.each do |path|
              node = @entities.find { _1.file.path == path }
              assert_kind_of AnonNode, node
              assert node.anon?
            end
          end
        end
      end
    end
  end
end
