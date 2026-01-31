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

      spec.data.yard_object = class_object

      comment = class_object.docstring.strip_heredoc
      if comment.present?
        spec.notes = TextSnippet.new(comment)
      end

      scenario_methods = class_object
        .meths(inherited: false, included: false)
        .filter { _1.visibility == :public }

      scenarios = scenario_methods.map(&method(:to_scenario))

      spec.add_warning("No scenarios defined") if scenarios.none?

      spec.push(*scenarios)
      spec
    end

    private def to_scenario(method_object)
      scenario = ScenarioNode.new(
        method_object.name,
        name: method_object.name,
        source: MethodSnippet.from_method_object(method_object)
      )

      scenario.data.yard_object = method_object

      comments = method_object.docstring.strip_heredoc
      scenario.notes = TextSnippet.new(comments) if comments.present?
      scenario
    end
  end

  YardParser.define_tags(YARD::Tag.subclasses)
end
