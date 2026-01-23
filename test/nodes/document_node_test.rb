require "support/test_helper"

module Booklet
  class DocumentNodeTest < Minitest::Test
    subject { DocumentNode }

    context "class methods" do
      context "DocumentNode::from" do
        context "called with a path that is not a markdown document" do
          should "raise an exception" do
            file_path = Fixtures.file("mixed/_tmp.txt")

            assert_raises(ArgumentError) { subject.from(file_path) }
          end
        end

        context "called with a markdown file path" do
          should "return a DocumentNode instance" do
            file_path = Fixtures.file("mixed/overview.md")

            assert_kind_of subject, subject.from(file_path)
          end
        end

        context "called with an markdown ERB file path" do
          should "return a DocumentNode instance" do
            file_path = Fixtures.file("mixed/docs/further_reading.md.erb")

            assert_kind_of subject, subject.from(file_path)
          end
        end
      end
    end
  end
end
