require "support/test_helper"

module Booklet
  class AnalyzerTest < Minitest::Test
    context "default analyzer setup" do
      context "#analyze" do
        setup do
          @analyzer = Analyzer.new
        end

        should "raise an exception when called without a root path" do
          assert_raises { analyzer.analyze }
        end
      end
    end
  end
end
