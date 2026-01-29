require "support/test_helper"

module Booklet
  class PreviewClassParserTest < Minitest::Test
    context "Preview classes" do
      setup do
        @spec_path = Fixtures.file("specs/example_preview.rb")
        @spec = SpecNode.from(@spec_path)
        @spec.accept(PreviewClassParser.new)
      end

      context "scenarios" do
        should "be created for each public instance method" do
          assert_equal ["default", "with_notes", "no_notes"], @spec.scenarios.map { _1.ref.raw }

          @spec.scenarios.each do |node|
            assert_kind_of ScenarioNode, node
          end
        end

        should "not be created for private methods" do
          refute @spec.scenarios.find { _1.ref == "not_a_scenario" }
        end
      end

      context "`default` scenario" do
        setup do
          @scenario = @spec.scenarios.find { _1.ref == "default" }
        end

        should "have a custom label" do
          assert_equal "Basic Example", @scenario.label
        end

        should "have a source snippet" do
          assert_kind_of MethodSnippet, @scenario.source
          assert_equal "render ExampleComponent.new", @scenario.source.to_s
        end
      end

      context "`with_notes` scenario" do
        setup do
          @scenario = @spec.scenarios.find { _1.ref == "with_notes" }
        end

        should "have notes" do
          assert_kind_of TextSnippet, @scenario.notes
          assert_equal "Notes specific to the _with notes_ scenario.", @scenario.notes.to_s
        end
      end

      context "`no_notes` scenario" do
        setup do
          @scenario = @spec.scenarios.find { _1.ref == "no_notes" }
        end

        should "not have notes" do
          assert_nil @scenario.notes
        end
      end
    end
  end
end
