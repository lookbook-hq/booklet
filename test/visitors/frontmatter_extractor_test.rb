require "support/test_helper"

module Booklet
  class FrontmatterExtractorTest < Minitest::Test
    context "Page without frontmatter" do
      setup do
        @page_path = Fixtures.file("pages/basic_page.md")
        @page = PageNode.from(@page_path)
        @page.accept(FrontmatterExtractor.new)
      end

      context "PageNode#frontmatter" do
        should "return an empty InheritableOptions hash" do
          assert_kind_of ActiveSupport::InheritableOptions, @page.frontmatter
          assert @page.frontmatter.empty?
        end
      end

      context "PageNode#contents" do
        should "return the entire contents of the file" do
          assert_equal File.read(@page_path).strip, @page.contents
        end
      end
    end

    context "Page with frontmatter" do
      setup do
        @page_path = Fixtures.file("pages/page_with_frontmatter.md")
        @page = PageNode.from(@page_path)
        @page.accept(FrontmatterExtractor.new)
      end

      context "PageNode#frontmatter" do
        should "return an InheritableOptions hash" do
          assert_kind_of ActiveSupport::InheritableOptions, @page.frontmatter
        end

        should "include all frontmatter data properties" do
          assert_equal "Page label", @page.frontmatter.label
          assert_equal "Title for the Page", @page.frontmatter.title
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
