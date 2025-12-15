require "test_helper"

describe Lookbook::Manifest do
  describe "#version" do
    it "returns the version number" do
      expect(Lookbook::Manifest.version).must_equal "0.0.0"
    end
  end
end
