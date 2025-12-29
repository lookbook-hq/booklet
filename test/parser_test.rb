require "support/test_helper"

module Booklet
  class ParserTest < Minitest::Test
    context "default parser" do
      context "#parse" do
        setup do
          @parser = Parser.new
        end

        should "raise an exception when called without a root path" do
          assert_raises { parser.parse }
        end
      end
    end
  end
end
