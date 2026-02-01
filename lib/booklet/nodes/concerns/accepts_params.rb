module Booklet
  module AcceptsParams
    extend ActiveSupport::Concern

    included do
      prop :params, _Nilable(Array), default: -> { [] }

      def add_param(param)
        @params << param
      end
    end
  end
end
