require "support/test_helper"

module Booklet
  class PreviewClassParserTest < Minitest::Test
    include FixtureHelpers

    context "preview class spec parser" do
      setup do
        @root_path = fixture_file("specs")
        @files = DirectoryNode.new("entities", path: @root_path).accept(FilesystemLoader.new)
        @entities = @files.accept(EntityTransformer.new)
      end

      context "parsing preview_class_spec_parser_preview.rb" do
        setup do
          @spec = @entities.find { _1.file.basename == "preview_class_spec_parser_preview.rb" }
          @spec.accept(PreviewClassParser.new)
        end

        context "spec" do
        end

        context "scenarios" do
          should "be created for each public instance method" do
            assert_equal ["default", "with_notes", "no_notes"], @spec.scenarios.map { _1.name }

            @spec.each_scenario do |node|
              assert_kind_of ScenarioNode, node
            end
          end

          should "not be created for private methods" do
            refute @spec.scenarios.find { _1.name == "not_a_scenario" }
          end
        end

        context "default scenario" do
          setup do
            @scenario = @spec.scenarios.find { _1.name == "default" }
          end

          should "have a source snippet" do
            assert_kind_of MethodSnippet, @scenario.source
            assert_equal "render ExampleComponent.new", @scenario.source.to_s
          end
        end

        context "with_notes scenario" do
          setup do
            @scenario = @spec.scenarios.find { _1.name == "with_notes" }
          end

          should "have notes" do
            assert_kind_of TextSnippet, @scenario.notes
            assert_equal "Notes specific to the _with notes_ scenario.", @scenario.notes.to_s
          end
        end

        context "no_notes scenario" do
          setup do
            @scenario = @spec.scenarios.find { _1.name == "no_notes" }
          end

          should "not have notes" do
            assert_nil @scenario.notes
          end
        end
      end
    end
  end
end
