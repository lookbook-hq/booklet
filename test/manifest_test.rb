require "test_helper"

module Lookbook
  class ManifestTest < Minitest::Test
    context ".version" do
      should "return the version number" do
        assert_equal "0.0.0", Manifest.version
      end
    end
  end
end
