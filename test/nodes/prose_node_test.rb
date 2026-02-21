require "support/test_helper"

module Booklet
  class ProseNodeTest < Minitest::Test
    context "ProseNode" do
      setup do
        @prose = ProseNode.new("Some markdown content")
      end

      context "#snippet" do
        should "return a TextSnippet" do
          assert_kind_of TextSnippet, @prose.snippet
        end

        should "contain the provided text" do
          assert_equal "Some markdown content", @prose.snippet.to_s
        end
      end

      context "initialization" do
        should "coerce string to TextSnippet" do
          prose = ProseNode.new("raw text")
          assert_kind_of TextSnippet, prose.snippet
        end
      end
    end
  end
end
