# frozen_string_literal: true

module Booklet
  class PreviewClassSpecParser < SpecParser
    after_initialize do
      @parser = YardParser.new
    end

    def parse(file, spec)
      class_object = @parser.parse_file(file.path)

      comments = strip_whitespace(class_object.docstring)
      if comments.present?
        spec.notes = TextSnippet.new(comments)
      end

      scenarios = class_object
        .meths(inherited: false, included: false)
        .filter { _1.visibility == :public }
        .map(&method(:to_scenario))

      spec.push(*scenarios)
    end

    protected def to_scenario(method_object)
      parameters = method_object.parameters # TODO: 'parameters' Value object

      source = MethodSnippet.new(
        method_object.source,
        name: method_object.path,
        lang: method_object.source_type,
        location: [method_object.file, method_object.line]
      )

      comments = strip_whitespace(method_object.docstring)
      notes = TextSnippet.new(comments) if comments.present?

      ScenarioNode.new(method_object.name, source:, parameters:, notes:)
    end
  end
end
