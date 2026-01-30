# Class-level notes
# -----------------
#
# General notes about the spec _subject_.
#
# @hidden true
class ExamplePreview < ViewComponent::Preview
  # Notes specific to the _default_ scenario.
  def default
    render ExampleComponent.new
  end

  # Notes specific to the _with notes_ scenario.
  def with_notes
    render ExampleComponent.new(size: :small)
  end

  def no_notes
    # No notes for this scenario
    render ExampleComponent.new(size: :large)
  end

  # @hidden true
  # @display text white
  # @display attrs {class_name: "bg-pink", id: "root"}
  # @label Tags Example
  def with_tags
    render ExampleComponent.new
  end

  private

  def not_a_scenario
  end
end
