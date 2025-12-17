# frozen_string_literal: true

module Booklet
  class Object < Literal::Object
    include ActiveSupport::Callbacks
    include Values
    include Helpers

    define_callbacks :initialize

    def after_initialize
      run_callbacks :initialize
    end

    class << self
      include Values

      def after_initialize(&)
        set_callback :initialize, :after, &
      end
    end
  end
end
