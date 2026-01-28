module Booklet
  module Hideable
    extend ActiveSupport::Concern

    included do
      prop :hidden, _Boolean?, writer: :public, reader: :public, default: false

      def hidden? = @hidden
    end
  end
end
