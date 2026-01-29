# frozen_string_literal: true

module Booklet
  module YARD
    module BooleanValueTag
      extend ActiveSupport::Concern

      included do
        def value = @text != "false"
      end
    end
  end
end
