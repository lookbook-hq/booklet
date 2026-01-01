module Booklet
  module LocatableAssertions
    extend ActiveSupport::Concern

    included do
      context "locatable class methods" do
        setup do
          @fixture_file = fixture_file("entity_file_types/example_document.md")
        end

        context ".from" do
          should "instantiate and return a new file node instance from a File instance" do
            assert_kind_of subject, subject.from(File.new(@fixture_file))
          end

          should "instantiate and return a new file node instance from a Pathname" do
            assert_kind_of subject, subject.from(@fixture_file)
          end

          should "instantiate and return a new file node instance from a path string" do
            assert_kind_of subject, subject.from(@fixture_file.to_s)
          end

          should "raise an argument error if an file is not provided" do
            assert_raises(ArgumentError) { subject.from }
          end
        end

        context ".locatable" do
          should "return true" do
            node = subject.from(@fixture_file)
            assert node.locatable?
          end
        end
      end

      context "locatable instance methods" do
        setup do
          @fixture_file = fixture_file("entity_file_types/example_document.md")
          @node = subject.from(@fixture_file)
        end

        context ".file" do
          should "returns a Booklet::File object instance" do
            assert_kind_of Booklet::File, @node.file
            assert_equal @fixture_file, @node.file.path
          end
        end
      end
    end
  end
end
