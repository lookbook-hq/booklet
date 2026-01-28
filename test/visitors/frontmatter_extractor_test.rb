require "support/test_helper"

module Booklet
  class FrontmatterExtractorTest < Minitest::Test
    context "Page without frontmatter" do
      setup do
        @page_path = Fixtures.file("pages/basic_page.md")
        @page = PageNode.from(@page_path)
        @page.accept(FrontmatterExtractor.new)
      end

      context "PageNode#contents" do
        should "return the entire contents of the file" do
          assert_equal File.read(@page_path).strip, @page.contents
        end
      end
    end

    context "Page with frontmatter" do
      context "valid frontmatter" do
        setup do
          @page_path = Fixtures.file("pages/page_with_frontmatter.md")
          @page = PageNode.from(@page_path)
          @page.accept(FrontmatterExtractor.new)
        end

        context "page label" do
          should "be set from the frontmatter" do
            assert_equal "Page label", @page.label
          end
        end

        context "page title" do
          should "be set from the frontmatter" do
            assert_equal "Title for the Page", @page.title
          end
        end

        context "page hidden status" do
          should "be set from the frontmatter" do
            assert_equal true, @page.hidden
          end
        end

        context "page data" do
          should "be set from the frontmatter" do
            assert_kind_of Options, @page.data
            assert_equal "baz", @page.data.foo.bar
          end
        end

        context "PageNode#contents" do
          should "return the file contents without the frontmatter section" do
            assert_equal "Page contents", @page.contents
          end
        end
      end
    end
  end
end
