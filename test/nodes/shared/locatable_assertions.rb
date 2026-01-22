module Booklet
  module LocatableAssertions
    extend ActiveSupport::Concern

    included do
      context "locatable class methods" do
        context ".from" do
          should "instantiate and return a new file node instance from a Pathname" do
            assert_kind_of subject, subject.from(@subject_file_path)
          end

          should "instantiate and return a new file node instance from a path string" do
            assert_kind_of subject, subject.from(@subject_file_path.to_s)
          end

          should "raise an argument error if an file is not provided" do
            assert_raises(ArgumentError) { subject.from }
          end
        end

        context ".locatable" do
          should "return true" do
            node = subject.from(@subject_file_path)
            assert node.locatable?
          end
        end
      end

      context "locatable instance methods" do
        setup do
          @subject_file_path = Pathname("/full/path/to/example.md")
          @node = subject.from(@subject_file_path)
        end

        context ".path" do
          should "returns a Pathname instance" do
            assert_kind_of Pathname, @node.path
            assert_equal @subject_file_path, @node.path
          end
        end
      end
    end
  end
end
