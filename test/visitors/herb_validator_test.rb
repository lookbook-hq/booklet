require "support/test_helper"
require "prism"

module Booklet
  class HerbValidatorTest < Minitest::Test
    context "Herb ERB validator" do
      setup do
        @root = Fixtures.dir("mixed")
        @result = Booklet.analyze(@root, visitors: [HerbValidator.new])
        @erb_files_with_errors = Fixtures.files_within(@root, grep: /template_with_error/)
      end

      should "identify all files with syntax errors" do
        nodes_with_errors = @result.filter(&:errors?)

        assert_equal @erb_files_with_errors.count, nodes_with_errors.count
      end
    end
  end
end
