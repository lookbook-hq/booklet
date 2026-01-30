# frozen_string_literal: true

module Booklet
  class PreviewClassParser < Visitor
    after_initialize do
      @parser = YardParser.new
    end

    visit SpecNode do |spec|
      if (spec.format != :preview_class) || spec.errors? || visited?(spec)
        return spec
      end

      begin
        class_object = @parser.parse_file(spec.path)
      rescue => error
        spec.add_error(error)
      end

      return spec unless class_object

      tags = YARD::TagSet.new(class_object.tags)
      spec.label = tags.label if tags.label
      spec.hidden = tags.hidden? if tags.hidden?

      comments = strip_whitespace(class_object.docstring)
      if comments.present?
        spec.notes = TextSnippet.new(comments)
      end

      scenarios = class_object
        .meths(inherited: false, included: false)
        .filter { _1.visibility == :public }
        .map(&method(:to_scenario))

      if scenarios.none?
        spec.add_warning("No scenarios defined")
      end

      spec.push(*scenarios)
    end

    protected def to_scenario(method_object)
      scenario = ScenarioNode.new(
        method_object.name,
        name: method_object.name,
        source: MethodSnippet.from_method_object(method_object)
      )

      comments = strip_whitespace(method_object.docstring)
      scenario.notes = TextSnippet.new(comments) if comments.present?

      tags = YARD::TagSet.new(method_object.tags)
      scenario.label = tags.label if tags.label
      scenario.hidden = tags.hidden? if tags.hidden?
      scenario.display_options = tags.display_options if tags.display_options.present?

      # scenario.parameters = method_object.parameters # TODO: 'parameters' Data object

      scenario
    end
  end

  YardParser.define_tags(YARD::Tag.subclasses)
end
