require "support/test_helper"

module Booklet
  class HashConverterTest < Minitest::Test
    include FixtureHelpers

    context "hash converter" do
      setup do
        @root_path = fixture_file("entities")
        @files = DirectoryNode.from(@root_path).accept(FilesystemLoader.new)
        @hash = @files.accept(HashConverter.new)
      end

      should "not mutate the visited tree" do
        assert_kind_of DirectoryNode, @files
      end

      should "return a hash with the expected number of (nested) items" do
        assert_kind_of Hash, @hash
        assert_equal @files.count, TestUtils.flatten_tree_hash(@hash).size
      end

      should "be nested to match the heirarchy of nodes in the tree" do
        @files.each_node do |node|
          ancestor_refs = (node.ancestors || []).reverse.map(&:ref)
          ancestor_refs.shift # ignore root node
          current = @hash
          while ancestor_refs.any?
            ref = ancestor_refs.shift
            entry = current[:children].find { _1[:ref] == ref.value }
            assert entry
            current = entry
          end
        end
      end

      context "with props option as an array of prop names" do
        setup do
          @props = [:path, :depth]
          @hash = @files.accept(HashConverter.new(props: @props))
        end

        should "be present in each hash" do
          hash_entries = TestUtils.flatten_tree_hash(@hash)

          hash_entries.each do |entry|
            file = @files.find { _1.ref == entry[:ref] }

            @props.each { assert entry[_1] == file.public_send(_1) }
          end
        end

        context "with props option as a props hash" do
          setup do
            @props = {path: true, derived: lambda { |file| file.basename }}
            @hash = @files.accept(HashConverter.new(props: @props))
          end

          should "be present in each hash" do
            hash_entries = TestUtils.flatten_tree_hash(@hash)

            hash_entries.each do |entry|
              file = @files.find { _1.ref == entry[:ref] }

              assert entry[:path] = file.path
              assert entry[:derived] = file.basename
            end
          end
        end
      end
    end
  end
end
