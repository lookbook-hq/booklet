# frozen_string_literal: true

module Booklet
  class ScenarioGrouper < Visitor
    visit SpecNode do |spec|
      return spec if spec.errors? || visited?(spec)

      visit_each(spec.scenarios)

      spec.scenarios.group_by(&:group).each do |key, scenarios|
        unless key.nil?
          ref = key.parameterize
          scenario_group = ScenarioNode.new(ref, name: ref).tap do |group|
            combined_source = scenarios.map(&:source).join("\n\n")

            group.source = CodeSnippet.new(combined_source, lang: :ruby) # TODO: handle mixed languages
            group.renderer = lambda do |view_context, **params|
              rendered_scenarios = scenarios.map { _1.render(view_context, **params) }
              view_context.safe_join(rendered_scenarios, "\n\n")
            end
          end

          spec.insert_child_before(scenario_group, scenarios.first)
        end
      end

      spec
    end

    visit ScenarioNode do |scenario|
      return scenario if scenario.errors? || visited?(scenario)

      if scenario.group.present?
        scenario.hidden = true
      end

      scenario
    end
  end
end
