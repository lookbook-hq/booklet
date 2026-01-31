require "support/test_helper"

module Booklet
  class PreviewClassParserTest < Minitest::Test
    context "Preview classes" do
      setup do
        @spec_path = Fixtures.file("specs/example_preview.rb")
        @spec = SpecNode.from(@spec_path)
        @spec.accept(PreviewClassParser.new).accept(YardTagsHandler.new)
      end

      context "tags" do
        should "be hidden" do
          assert_equal true, @spec.hidden?
        end

        should "have display options" do
          assert_kind_of Options, @spec.display_options

          assert_equal "green", @spec.display_options.text
        end
      end

      context "scenarios" do
        should "be created for each public instance method" do
          assert_equal ["default", "with_notes", "no_notes", "with_tags"], @spec.scenarios.map { _1.ref.raw }

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

        should "have a source snippet" do
          assert_kind_of MethodSnippet, @scenario.source
          assert_equal "render ExampleComponent.new", @scenario.source.to_s
        end

        should "have display options inherited from spec" do
          assert_kind_of Options, @scenario.display_options

          assert_equal "green", @scenario.display_options.text
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

      context "scenario with tags" do
        setup do
          @scenario = @spec.scenarios.find { _1.ref == "with_tags" }
        end

        should "be hidden" do
          assert_equal true, @scenario.hidden?
        end

        should "be labelled" do
          assert_equal "Tags Example", @scenario.label
        end

        should "have display options" do
          assert_kind_of Options, @scenario.display_options

          assert_equal "white", @scenario.display_options.text
          assert_equal "bg-pink", @scenario.display_options.attrs.class_name
        end
      end
    end
  end
end
