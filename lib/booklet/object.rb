# frozen_string_literal: true

module Booklet
  class Object < Literal::Object
    class << self
      include Values
    end
  end
end
