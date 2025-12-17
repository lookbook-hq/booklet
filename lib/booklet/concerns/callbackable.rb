# frozen_string_literal: true

module Booklet
  module Callbackable
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks

    included do
      define_callbacks :initialize

      def after_initialize
        run_callbacks :initialize
      end
    end

    class_methods do
      def after_initialize(&)
        set_callback :initialize, :after, &
      end
    end
  end
end
