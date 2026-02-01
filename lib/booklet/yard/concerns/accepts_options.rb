# frozen_string_literal: true

module Booklet
  module YARD
    module AcceptsOptions
      extend ActiveSupport::Concern

      included do
        def options
          TagOptions.new(options_string)
        end
      end
    end
  end
end
