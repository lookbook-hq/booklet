# frozen_string_literal: true

module Booklet
  class ScenarioGrouper < Visitor
    visit SpecNode do |spec|
      return spec if spec.errors? || visited?(spec)

      visit_each(spec.scenarios)

      spec.scenarios.group_by(&:group).each do |key, scenarios|
        unless key.nil?
          name = key.parameterize
          scenario_group = ScenarioNode.new(name:).tap do |group|
            combined_source = scenarios.map { _1.source.to_s.strip }.join("\n\n")

            group << CodeNode.new(combined_source, lang: :ruby) # TODO: handle mixed languages

            group.renderer = lambda do |**params|
              rendered_scenarios = scenarios.map { render(_1, **params).to_s.strip.html_safe }
              safe_join(rendered_scenarios, "\n\n")
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
