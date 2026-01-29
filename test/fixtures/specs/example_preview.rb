# Class-level notes
# -----------------
#
# General notes about the spec _subject_.
#
# @hidden true
class ExamplePreview < ViewComponent::Preview
  # Notes specific to the _default_ scenario.
  #
  # @label Basic Example
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
  def hidden_example
    render ExampleComponent.new
  end

  private

  def not_a_scenario
  end
end
