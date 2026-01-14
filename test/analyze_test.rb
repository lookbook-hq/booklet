require "support/test_helper"

module Booklet
  class AnalyzeTest < Minitest::Test
    context "Booklet.analyze" do
      context "with default visitors" do
        setup do
          @root = Fixtures.dir("mixed")
          @result = Booklet.analyze(@root)
        end

        should "return an abstract booklet tree" do
          assert_kind_of Tree, @result
        end

        context "Tree#files" do
          should "return a file tree containing all expected files and folders" do
            assert_kind_of DirectoryNode, @result.files

            assert_equal(
              Fixtures.files_within(@root).count,
              @result.files.reject(&:root?).count # @result.files includes the root directory, files_within doesn't.
            )
          end
        end

        context "Tree#issues" do
          should "be an issue log instance" do
            assert_kind_of Issues, @result.issues
          end

          should "include issues collected from all nodes in the tree" do
            ruby_files_with_errors = Fixtures.files_within(@root, grep: /syntax_error/)

            assert_equal ruby_files_with_errors.size, @result.errors.group_by { _1.node }.count
          end
        end

        context "Tree#to_h" do
          setup do
            @hash = @result.to_h
          end

          should "convert the tree to a hash" do
            assert_kind_of Hash, @hash
          end
        end

        context "entity conversion" do
          context "FolderNode" do
            should "be created for each directory node" do
              dirs = Fixtures.files_within(@root).filter(&:directory?)
              folders = @result.grep(FolderNode).reject(&:root?)

              assert_equal dirs.count, folders.count
              assert_equal 0, folders.map(&:path).difference(dirs).count
            end
          end

          context "PreviewClassNode" do
            should "be created for each preview class" do
              spec_files = Fixtures.spec_files_within(@root).filter { _1.basename.to_s.end_with?("_preview.rb") }
              specs = @result.grep(PreviewClassNode)

              assert_equal spec_files.count, specs.count
              assert_equal 0, specs.map(&:path).difference(spec_files).count
            end

            should "match SpecNodes" do
              spec_files = Fixtures.spec_files_within(@root)
              specs = @result.grep(SpecNode)

              assert_equal spec_files.count, specs.count
              assert_equal 0, specs.map(&:path).difference(spec_files).count
            end
          end

          context "BookletSpecNode" do
            should "be created for each booklet spec file" do
              spec_files = Fixtures.spec_files_within(@root).filter { _1.basename.to_s.end_with?("_booklet.rb") }
              specs = @result.grep(BookletSpecNode)

              assert_equal spec_files.count, specs.count
              assert_equal 0, specs.map(&:path).difference(spec_files).count
            end
          end

          context "DocumentNode" do
            should "be created for each matching markdown file" do
              doc_files = Fixtures.markdown_files_within(@root)
              docs = @result.grep(DocumentNode)

              assert_equal doc_files.count, docs.count
              assert_equal 0, docs.map(&:path).difference(doc_files).count
            end
          end

          context "AssetNode" do
            should "be created from each asset file" do
              asset_files = Fixtures.asset_files_within(@root)
              assets = @result.grep(AssetNode)

              assert_equal asset_files.count, assets.count
              assert_equal 0, assets.map(&:path).difference(asset_files).count
            end
          end

          context "AnonNode" do
            should "be created from all other files" do
              unrecognised_files = Fixtures.anon_files_within(@root)
              anon = @result.grep(AnonNode)

              assert_equal unrecognised_files.count, anon.count
              assert_equal 0, anon.map(&:path).difference(unrecognised_files).count
            end
          end
        end

        # context "Tree#to_ascii" do
        #   setup do
        #     @ascii_tree = @result.to_ascii
        #   end

        #   should "convert the tree to an ascii representation" do
        #     assert_kind_of String, @ascii_tree

        #     expected = <<~TREE
        #       Mixed
        #       ├── _config
        #       ├── _tmp
        #       ├── Components
        #       │   ├── README
        #       │   ├── Elements
        #       │   │   ├── button_booklet
        #       │   │   ├── Link Preview
        #       │   │   │   └── default
        #       │   │   └── Link Preview
        #       │   │       └── Default
        #       │   └── Notifications
        #       │       └── Toast Preview
        #       │           └── Default
        #       ├── Docs
        #       │   ├── 01_index
        #       │   ├── 02_installation
        #       │   ├── 03 Usage
        #       │   │   ├── 01_get_started
        #       │   │   ├── 02 Basic Preview
        #       │   │   │   ├── View Component
        #       │   │   │   └── Phlex
        #       │   │   ├── 04_next_steps
        #       │   │   └── _config
        #       │   └── further_reading
        #       └── overview
        #     TREE

        #     assert_equal expected.strip_heredoc.strip, @ascii_tree
        #   end
        # end
      end
    end
  end
end
