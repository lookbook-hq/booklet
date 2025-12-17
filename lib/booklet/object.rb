# frozen_string_literal: true

module Booklet
  class Object < Literal::Object
    include Values
    include Helpers

    class << self
      include Values
      include Helpers
    end
  end
end
