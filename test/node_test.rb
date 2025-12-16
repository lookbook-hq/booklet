require "support/test_helper"

module Booklet
  class NodeTest < Minitest::Test
    context "class methods" do
      context ".new" do
        should "succeeds when instatiated with a <String> name" do
          assert_kind_of Node, Node.new("chunky-bacon")
        end

        should "raise an argument error if an name is not provided" do
          assert_raises(ArgumentError) { Node.new }
        end
      end
    end

    context "instance methods" do
      setup do
        @root = Node.new("book")

        @child = Node.new("section-1")
        @child_2 = Node.new("section-2")
        @child_3 = Node.new("section-3")
        @grandchild = Node.new("chapter-1")
        @greatgrandchild = Node.new("paragraph-1")
      end

      context "#add" do
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

        should "prevent nodes being added multiple times" do
          @root << @child
          assert_raises(ArgumentError) { @root << @child }
        end

        should "prevent non-root nodes being added" do
          @child << @grandchild
          assert_raises(ArgumentError) { @root << @grandchild }
        end
      end

      context "#children" do
        setup do
          @root << @child
          @root << @child_2
          @root << @child_3
        end

        should "return an array of child nodes" do
          assert_equal 3, @root.children.size
          assert_equal [@child, @child_2, @child_3], @root.children
        end

        should "return a copy of the children so they cannot be mutated" do
          children = @root.children
          children << Node.new("blixy")

          assert_equal 4, children.size
          assert_equal 3, @root.children.size

          children.shift

          assert_equal @child_2, children[0]
          assert_equal @child, @root.children[0]

          # children[0]
        end
      end

      context "#root" do
        should "return the root node" do
          @root << @child << @grandchild

          assert_equal @root, @grandchild.root
          assert @root.name == "book"
        end
      end
    end
  end
end
