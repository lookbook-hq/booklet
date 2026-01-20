require "support/test_helper"

module Booklet
  class GlobalConfigTest < Minitest::Test
    context "Booklet global config options" do
      context "Booklet::loader" do
        should "returns the entity loader" do
          assert Booklet.loader == EntityLoader
        end

        should "be able to be replaced" do
          default_loader = Booklet.loader
          Booklet.loader = EntityLoader.new

          assert_kind_of EntityLoader, Booklet.loader

          Booklet.loader = default_loader
        end
      end

      context "Booklet::visitors" do
        should "returns a array of entity visitors" do
          assert_kind_of Array, Booklet.visitors
          assert Booklet.visitors.count > 0

          Booklet.visitors.each do |visitor|
            assert_kind_of Class, visitor
            assert visitor < Visitor
          end
        end

        should "be able to be mutated" do
          count = Booklet.visitors.count
          Booklet.visitors.push(HashConverter)

          assert Booklet.visitors.count == count + 1
          assert Booklet.visitors.include?(HashConverter)

          Booklet.visitors.pop
        end
      end
    end
  end
end
