module Booklet
  module LocatableAssertions
    extend ActiveSupport::Concern

    included do
      context "locatable class methods" do
        setup do
          @file_path = Pathname("/full/path/to/example.md")
        end

        context ".from" do
          should "instantiate and return a new file node instance from a File instance" do
            assert_kind_of subject, subject.from(File.new(@file_path))
          end

          should "instantiate and return a new file node instance from a Pathname" do
            assert_kind_of subject, subject.from(@file_path)
          end

          should "instantiate and return a new file node instance from a path string" do
            assert_kind_of subject, subject.from(@file_path.to_s)
          end

          should "raise an argument error if an file is not provided" do
            assert_raises(ArgumentError) { subject.from }
          end
        end

        context ".locatable" do
          should "return true" do
            node = subject.from(@file_path)
            assert node.locatable?
          end
        end
      end

      context "locatable instance methods" do
        setup do
          @file_path = Pathname("/full/path/to/example.md")
          @node = subject.from(@file_path)
        end

        context ".file" do
          should "returns a Booklet File object instance" do
            assert_kind_of File, @node.file
            assert_equal @file_path, @node.file.path
          end
        end
      end
    end
  end
end
