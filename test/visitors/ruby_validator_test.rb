require "support/test_helper"
require "prism"

module Booklet
  class RubyValidatorTest < Minitest::Test
    include FixtureHelpers

    context "ruby file syntax validator" do
      setup do
        @root_path = fixture_file("with_errors")
        @entity_tree = EntityTree.from(@root_path).accept(RubyValidator.new)
      end

      should "identify all files with syntax errors" do
        nodes_with_errors = @entity_tree.filter { _1.errors? }

        assert_equal 2, nodes_with_errors.size
      end

      should "add parser errors onto the node" do
        syntax_error_node = @entity_tree.find { _1.file.basename.to_s == "syntax_error_preview.rb" }
        no_error_node = @entity_tree.find { _1.file.basename.to_s == "no_error.rb" }

        assert_equal 2, syntax_error_node.errors.size
        assert_equal 0, no_error_node.errors.size
      end
    end
  end
end
