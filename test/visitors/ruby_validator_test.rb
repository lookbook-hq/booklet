require "support/test_helper"
require "prism"

module Booklet
  class RubyValidatorTest < Minitest::Test
    include FixtureHelpers

    context "ruby file syntax validator" do
      setup do
        @root_path = fixture_file("with_errors")
        @entities = DirectoryNode.from(@root_path)
          .accept(FilesystemLoader.new)
          .accept(EntityTransformer.new)
          .accept(RubyValidator.new)
      end

      should "add parser errors onto the node" do
        file_with_syntax_error = @entities.find { _1.file.basename.to_s == "syntax_error_preview.rb" }
        file_with_no_error = @entities.find { _1.file.basename.to_s == "no_error.rb" }

        assert_equal 2, file_with_syntax_error.errors.size
        assert_equal 0, file_with_no_error.errors.size

        file_with_syntax_error.errors.each do |issue|
          assert_kind_of Issue, issue
          assert_kind_of Prism::ParseError, issue.original_error
        end
      end
    end
  end
end
