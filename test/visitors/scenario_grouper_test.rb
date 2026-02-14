require "support/test_helper"

module Booklet
  class ScenarioGrouperTest < Minitest::Test
    context "ScenarioGrouper" do
      setup do
        @spec = spec_from_fixture("specs/grouped_preview.rb",
          visitors: [PreviewClassParser, YardTagsHandler, ScenarioGrouper])
      end

      context "grouped scenarios" do
        should "create a combined ScenarioNode for each group" do
          group = @spec.scenarios.find { _1.ref == "sizes" }

          assert_kind_of ScenarioNode, group
        end

        should "label the group node from the group name" do
          group = @spec.scenarios.find { _1.ref == "sizes" }

          assert_equal "Sizes", group.label
        end

        should "hide individual grouped scenarios" do
          small = @spec.scenarios.find { _1.ref == "small" }
          medium = @spec.scenarios.find { _1.ref == "medium" }
          large = @spec.scenarios.find { _1.ref == "large" }

          assert small.hidden?
          assert medium.hidden?
          assert large.hidden?
        end

        should "not hide ungrouped scenarios" do
          default = @spec.scenarios.find { _1.ref == "default" }
          themed = @spec.scenarios.find { _1.ref == "themed" }

          refute default.hidden?
          refute themed.hidden?
        end
      end

      context "group node position" do
        should "insert group before the first grouped scenario" do
          children_refs = @spec.children.map { _1.ref.raw }
          sizes_index = children_refs.index("sizes")
          small_index = children_refs.index("small")

          assert sizes_index < small_index
        end
      end
    end
  end
end
