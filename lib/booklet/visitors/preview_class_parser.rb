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

      spec = apply_tags(spec, class_object)

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

      apply_tags(scenario, method_object)

      # scenario.parameters = method_object.parameters # TODO: 'parameters' Data object
    end

    private def apply_tags(target, yard_obj)
      tags = target.data.tags = YARD::TagSet.new(yard_obj.tags)

      tags.names.each do |key|
        case key
        when :label
          target.label = tags.label_tag&.value
        when :hidden
          target.hidden = tags.hidden_tag&.value || false
        when :display
          display_options = tags.display_tags.map { [_1.key, _1.value] }
          target.display_options = display_options.to_h.deep_symbolize_keys!
        else
          if target.respond_to?(key)
            target.public_send("#{key}=", tags.find { _1.identifier == key }.value)
          end
        end
      end

      target
    end
  end

  YardParser.define_tags(YARD::Tag.subclasses)
end
