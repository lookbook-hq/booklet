# frozen_string_literal: true

require "active_support/dependencies/require_dependency"
require "view_component/preview"
require "lookbook/preview"

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
        require_dependency class_object.file # TODO: handle this more elegantly?
      rescue => error
        spec.add_error(error)
      end

      return spec unless class_object

      notes = class_object.docstring.strip_heredoc
      spec.notes = TextSnippet.new(notes) if notes.present?

      tags = YARD::TagSet.new(class_object.tags)
      spec.data.tap do |data|
        data.yard_object = class_object
        data.yard_tags = tags
      end

      # Any @param and @display tags set at the class level
      # act as defaults for all scenario methods, unless overridden.
      default_tags = [*tags.param_tags, *tags.display_tags]

      scenarios = class_object
        .meths(inherited: false, included: false)
        .filter { _1.visibility == :public }
        .map { create_scenario(_1, default_tags) }

      spec.add_warning("No scenarios defined") if scenarios.none?
      spec.push(*scenarios)
      spec
    end

    private def create_scenario(method_object, default_tags = [])
      name = method_object.name
      context = method_object.parent.path

      ScenarioNode.new(name, name:, context:).tap do |scenario|
        scenario.source = MethodSnippet.from_code_object(method_object)
        scenario.group = method_object.group

        notes = method_object.docstring.strip_heredoc
        scenario.notes = TextSnippet.new(notes) if notes.present?

        method_params = method_object.parameters.map { [_1.first.delete_suffix(":").to_sym, _1.last] }.to_h
        params = method_params.map do |name, raw_value|
          Param.new(name,
            required: raw_value.nil?,
            default_value: raw_value.nil? ? nil : -> { scenario.context.instance_eval(raw_value) })
        end

        scenario.params.push(params)

        scenario.data.tap do |data|
          data.yard_object = method_object
          data.yard_tags = YARD::TagSet.new([*default_tags, *method_object.tags])
        end
      end
    end
  end

  YardParser.define_tags(YARD::Tag.subclasses)
end
