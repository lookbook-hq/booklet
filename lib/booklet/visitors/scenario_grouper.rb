# frozen_string_literal: true

module Booklet
  class ScenarioGrouper < Visitor
    visit SpecNode do |spec|
      return spec if spec.errors? || visited?(spec)

      visit_each(spec.scenarios)

      groups = spec.scenarios.group_by { _1.group }

      groups.each do |key, scenarios|
        unless key.nil?
          ref = key.parameterize
          scenario_group = ScenarioNode.new(ref, name: ref).tap do |scenario|
            combined_source = scenarios.map { _1.source.to_s }.join("\n\n")
            scenario.source = CodeSnippet.new(combined_source, lang: :ruby) # TODO: handle mixed languages
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
