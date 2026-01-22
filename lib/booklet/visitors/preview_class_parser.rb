# frozen_string_literal: true

require "prism"

module Booklet
  class PreviewClassParser < Visitor
    after_initialize do
      @yard = YardParser.new
    end

    visit PreviewClassNode do |spec|
      return spec if spec.errors? || visited?(spec)

      begin
        class_object = @yard.parse_file(spec.path)
      rescue => error
        spec.add_error(error)
      end

      return spec unless class_object

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
      parameters = method_object.parameters # TODO: 'parameters' Data object

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
