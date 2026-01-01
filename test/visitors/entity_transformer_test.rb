require "support/test_helper"

module Booklet
  class EntityTransformerTest < Minitest::Test
    include FixtureHelpers

    context "the transformer" do
      setup do
        @root_path = fixture_file("entities")

        @files = DirectoryNode.from(@root_path).accept(FilesystemLoader.new)
      end

      context "when visiting a tree of file nodes" do
        # should "transform all nodes" do
        #   entities = @files.accept(EntityTransformer.new)
        #   entities.each_node do |node|
        #     assert_kind_of EntityNode, node
        #   end

        #   assert_equal fixture_file_descendants(@root_path).size, entities.descendants.size
        # end

        should "not mutate the original file tree" do
          @files.accept(EntityTransformer.new)
          @files.each_node do |node|
            assert node.class.in?([DirectoryNode, FileNode])
          end
        end
      end

      context "file to entity conversion" do
        setup do
          @entities = @files.accept(EntityTransformer.new)
        end

        context "folder nodes" do
          should "be created from directory nodes" do
            dirs = fixture_file_descendants(@root_path).filter(&:directory?)
            assert dirs.size > 0

            dirs.each do |path|
              assert_kind_of FolderNode, @entities.find { _1.file.path == path }
            end
          end
        end

        context "view spec nodes" do
          should "be created from *_preview.rb files" do
            spec_files = fixture_file_descendants(@root_path).filter { _1.to_s.end_with?("_preview.rb") }

            assert spec_files.size
            assert_equal spec_files.size, @entities.count(&:spec?)

            spec_files.each do |path|
              spec = @entities.find { _1.file.path == path }
              assert_kind_of SpecNode, spec
              assert spec.spec?
            end
          end
        end

        context "document nodes" do
          should "be created from markdown files" do
            doc_files = fixture_file_descendants(@root_path).filter { _1.basename.to_s.end_with?(".md", ".md.erb") }
            assert doc_files.size
            assert_equal doc_files.size, @entities.count(&:document?)

            doc_files.each do |path|
              doc = @entities.find { _1.file.path == path }
              assert_kind_of DocumentNode, doc
              assert doc.document?
            end
          end
        end

        context "asset nodes" do
          should "be created from css, js and image files" do
            asset_files = fixture_file_descendants(@root_path).filter { _1.extname.in?([".css", ".js", ".png", ".gif"]) }
            assert asset_files.size
            assert_equal asset_files.size, @entities.count(&:asset?)

            asset_files.each do |path|
              asset = @entities.find { _1.file.path == path }
              assert_kind_of AssetNode, asset
              assert asset.asset?
            end
          end
        end

        # context "anon nodes" do
        #   should "be created from any other files" do
        #     asset_files = fixture_file_descendants(@root_path).filter { _1.extname.in?([".erb", ".yml", ".png", ".gif"]) }
        #     assert asset_files.size
        #     assert_equal asset_files.size, @entities.count(&:asset?)

        #     asset_files.each do |path|
        #       asset = @entities.find { _1.file.path == path }
        #       assert_kind_of AssetNode, asset
        #       assert asset.asset?
        #     end
        #   end
        # end
      end
    end
  end
end
