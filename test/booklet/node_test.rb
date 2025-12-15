require "test_helper"

module Booklet
  class NodeTest < Minitest::Test
    def setup
      @root = Node.new("root")

      @child = Node.new("child")
      @child_2 = Node.new("child_2")
      @child_3 = Node.new("child_3")
      @grandchild = Node.new("grandchild")
      @greatgrandchild = Node.new("greatgrandchild")
    end

    context "#new" do
      should "raise an argument error if an id is not provided" do
        assert_raises(ArgumentError) { Node.new }
      end

      should "raise an type error if an non-string id is provided" do
        assert_raises(TypeError) { Node.new(1) }
        assert_raises(TypeError) { Node.new(:foo) }
      end

      should "succeeds with a string id" do
        assert_kind_of Node, Node.new("yay!")
      end
    end

    context ".add" do
      should "allow child nodes to be added" do
        @root << @child
        @root << @child_2
        @root << @child_3

        assert_equal 3, @root.children.size
        assert_contains @root.children, @child
        assert_contains @root.children, @child_2
        assert_contains @root.children, @child_3
      end

      should "allow multiple levels of children" do
        @root << @child << @grandchild << @greatgrandchild

        assert_contains @root.children, @child
        assert_contains @child.children, @grandchild
        assert_contains @grandchild.children, @greatgrandchild

        assert_equal 1, @root.children.size
        assert_does_not_contain @root.children, @grandchild
        assert_does_not_contain @root.children, @greatgrandchild
      end

      should "prevent non-Node objects being added" do
        assert_raises(ArgumentError) { @root << Object.new }
      end
    end

    context ".children" do
      setup do
        @root << @child
        @root << @child_2
        @root << @child_3
      end

      should "return an array of child nodes" do
        assert_equal 3, @root.children.size
        assert_equal [@child, @child_2, @child_3], @root.children
      end
    end

    context ".root" do
      should "return the root node" do
        @root << @child << @grandchild

        assert_equal @root, @grandchild.root
      end
    end
  end
end
