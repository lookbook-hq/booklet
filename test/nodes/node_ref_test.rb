require "support/test_helper"

module Booklet
  class NodeRefTest < Minitest::Test
    context "NodeRef" do
      setup do
        @ref = NodeRef.new("my-node")
      end

      context "#raw" do
        should "return original string" do
          assert_equal "my-node", @ref.raw
        end
      end

      context "#value" do
        should "return hexdigest" do
          assert_equal Helpers.hexdigest("my-node"), @ref.value
        end
      end

      context "#to_s" do
        should "return value" do
          assert_equal @ref.value, @ref.to_s
        end
      end

      context "#==" do
        should "be equal to another NodeRef with the same raw value" do
          other = NodeRef.new("my-node")
          assert_equal @ref, other
        end

        should "be equal when compared with raw string" do
          assert @ref == "my-node"
        end

        should "be equal when compared with value string" do
          assert @ref == @ref.value
        end

        should "not be equal to a different raw string" do
          refute @ref == "other-node"
        end
      end
    end
  end
end
