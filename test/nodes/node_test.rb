require "support/test_helper"

module Booklet
  class NodeTest < Minitest::Test
    context "class methods" do
      context "NodeTest::new" do
        should "succeeds when instatiated with a <String> value for the :ref property" do
          assert_kind_of Node, Node.new("chunky-bacon")
        end

        should "raise an argument error if a :ref is not provided" do
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
        @greatgrandchild_2 = Node.new("paragraph-2")
      end

      context "Node#add" do
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

      context "Node#children" do
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
        end
      end

      context "Node#each_node" do
        setup do
          @root << @child
          @root << @child_2
          @root << @child_3
          @child_2 << @grandchild << @greatgrandchild
          @grandchild << @greatgrandchild_2

          @node_refs = %w[book section-1 section-2 chapter-1 paragraph-1 paragraph-2 section-3]
        end

        should "return a _depth-first_, _left-to-right_ iterator for [node, *descendants]" do
          assert_equal 7, @root.each_node.count

          assert_equal @node_refs, @root.each_node.map(&:ref).map(&:raw)
        end

        should "yield each node from [node, *descendants] when a block is provided" do
          refs = []

          @root.each_node do |node|
            assert_kind_of Node, node
            refs << node.ref.raw
          end

          assert_equal @node_refs, refs
        end
      end

      context "Node#root" do
        should "return the root node" do
          @root << @child << @grandchild

          assert_equal @root, @grandchild.root
          assert @root.ref == "book"
        end
      end

      context "comparison" do
        setup do
          @root << @child
          @root << @child_2
          @root << @child_3
          @child_2 << @grandchild << @greatgrandchild
          @grandchild << @greatgrandchild_2
        end

        context "greater than" do
          should "return true for a node above/before the other" do
            assert @root > @child
            assert @child > @grandchild
            assert @child_2 > @child_3
          end
        end

        context "less than" do
          should "return true for a node below/after the other" do
            assert @greatgrandchild_2 < @child
            assert @child_2 < @child
            assert @child_2 < @root
          end
        end
      end

      context "issues" do
        setup do
          @node = Node.new("issues")
        end

        context "Node#add_warning" do
          should "push a warning onto the node issues list" do
            @node.add_warning("Unwise thing to do")
            warning = @node.warnings.first

            assert @node.warnings?
            assert_equal 1, @node.warnings.count
            assert_kind_of Warning, warning
            assert_equal "Unwise thing to do", warning.message
          end
        end

        context "Node#add_error" do
          should "push an error onto the node issues list" do
            @node.add_error("Something went wrong")
            error = @node.errors.first

            assert @node.errors?
            assert_equal 1, @node.errors.size
            assert_kind_of Error, error
            assert_equal "Something went wrong", error.message
          end
        end
      end
    end
  end
end
