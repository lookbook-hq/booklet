require "support/test_helper"

module Booklet
  class BookletTest < Minitest::Test
    context ".version" do
      should "return the version number" do
        assert_equal "0.0.1", Booklet.version
      end
    end
  end
end
