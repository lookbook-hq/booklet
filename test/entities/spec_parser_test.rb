require "support/test_helper"

module Booklet
  class SpecParserTest < Minitest::Test
    include FixtureHelpers

    context "view specifications in the ViewComponent-style `Preview` class format" do
      setup do
        @root_path = fixture_file("specs")
        @files = DirectoryNode.from(@root_path).accept(FilesystemLoader.new)
        @entities = @files.accept(EntityTransformer.new)

        @specs = @entities.find { _1.file.basename == "preview_class_spec_parser_preview.rb" }
        @specs.accept(PreviewClassParser.new)
      end

      context "view spec" do
      end

      context "scenarios" do
        should "be created for each public instance method" do
          assert_equal ["default", "with_notes", "no_notes"], @specs.scenarios.map { _1.ref }

          @specs.each_scenario do |node|
            assert_kind_of ScenarioNode, node
          end
        end

        should "not be created for private methods" do
          refute @specs.scenarios.find { _1.ref == "not_a_scenario" }
        end
      end

      context "default scenario" do
        setup do
          @scenario = @specs.scenarios.find { _1.ref == "default" }
        end

        should "have a source snippet" do
          assert_kind_of MethodSnippet, @scenario.source
          assert_equal "render ExampleComponent.new", @scenario.source.to_s
        end
      end

      context "with_notes scenario" do
        setup do
          @scenario = @specs.scenarios.find { _1.ref == "with_notes" }
        end

        should "have notes" do
          assert_kind_of TextSnippet, @scenario.notes
          assert_equal "Notes specific to the _with notes_ scenario.", @scenario.notes.to_s
        end
      end

      context "no_notes scenario" do
        setup do
          @scenario = @specs.scenarios.find { _1.ref == "no_notes" }
        end

        should "not have notes" do
          assert_nil @scenario.notes
        end
      end
    end
  end
end
