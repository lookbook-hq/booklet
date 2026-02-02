# frozen_string_literal: true

module Booklet
  class YardTagsHandler < Visitor
    visit SpecNode do |spec|
      return spec if !spec.data.yard_tags || spec.errors? || visited?(spec)

      apply_tags(spec)
      visit_each(spec.scenarios)
      spec
    end

    visit ScenarioNode do |scenario|
      return scenario if !scenario.data.yard_tags || scenario.errors? || visited?(scenario)

      apply_tags(scenario)
    end

    private def apply_tags(node)
      tags = node.data.yard_tags

      node.tap do |n|
        node.label = tags.label_tag.value if tags.label_tag
        node.hidden = tags.hidden_tag.value if tags.hidden_tag

        tags.display_tags.each do |tag|
          node.display_options = node.display_options.merge(tag.value)
        end

        tags.param_tags.each do |tag|
          param_data = tag.value

          if tag.options_string.present?
            param_data[:options] = lambda do
              context = node.try(:context) || Object
              Options.resolve_from(context, tag.options_string)
            end
          end

          node.params.update(tag.name, param_data)
        end

        tags.other_tags.each do |tag|
          node.try("#{tag.tag_name}=", tag.value)
        end
      end
    end
  end
end
