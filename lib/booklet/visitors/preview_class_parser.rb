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

      comment = class_object.docstring.strip_heredoc
      if comment.present?
        spec.notes = TextSnippet.new(comment)
      end

      tags = YARD::TagSet.new(class_object.tags)
      spec.data.tap do |data|
        data.yard_object = class_object
        data.yard_tags = tags
      end

      scenario_methods = class_object
        .meths(inherited: false, included: false)
        .filter { _1.visibility == :public }

      scenarios = scenario_methods.map do |method|
        create_scenario(method, default_tags: [*tags.param_tags, *tags.display_tags])
      end

      spec.add_warning("No scenarios defined") if scenarios.none?

      spec.push(*scenarios)
      spec
    end

    private def create_scenario(method_object, default_tags: [])
      ScenarioNode.new(
        method_object.name,
        name: method_object.name,
        source: MethodSnippet.from_method_object(method_object)
      ).tap do |scenario|
        comments = method_object.docstring.strip_heredoc
        scenario.notes = TextSnippet.new(comments) if comments.present?

        scenario.data.tap do |data|
          data.yard_object = method_object
          data.yard_tags = YARD::TagSet.new([*default_tags, *method_object.tags])
        end
      end
    end
  end

  YardParser.define_tags(YARD::Tag.subclasses)
end
