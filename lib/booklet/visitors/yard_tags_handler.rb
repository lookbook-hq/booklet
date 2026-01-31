# frozen_string_literal: true

module Booklet
  class YardTagsHandler < Visitor
    visit SpecNode do |spec|
      return spec if spec.errors? || visited?(spec)

      apply_tags(spec)
      visit_each(spec.scenarios)

      spec
    end

    visit ScenarioNode do |scenario|
      return scenario if scenario.errors? || visited?(scenario)

      apply_tags(scenario, display_options: scenario.spec.display_options)

      scenario
    end

    private def apply_tags(node, **defaults)
      tags = node.data.yard_object&.tags || []
      label_tags = tags.grep(YARD::LabelTag)
      hidden_tags = tags.grep(YARD::HiddenTag)
      display_option_tags = tags.grep(YARD::DisplayOptionsTag)
      other_tags = tags.difference(label_tags + hidden_tags + display_option_tags)

      node.tap do |n|
        n.label = label_tags.last&.value
        n.hidden = hidden_tags.last&.value

        option_sets = [
          defaults[:display_options].to_h,
          display_option_tags.map(&:to_h),
          n.display_options
        ]

        n.display_options = option_sets.flatten.inject(&:merge)

        other_tags.each do |tag|
          if n.respond_to?(tag.identifier)
            n.public_send("#{tag.identifier}=", tag.value)
          end
        end
      end
    end
  end
end
