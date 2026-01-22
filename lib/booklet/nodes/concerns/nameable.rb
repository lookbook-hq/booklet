module Booklet
  module Nameable
    extend ActiveSupport::Concern

    included do
      prop :name, String, reader: :public, writer: :public
      prop :label, _Nilable(String), writer: :public
      prop :title, _Nilable(String), writer: :public

      def label
        @label ||= name.titleize
      end

      def title
        @title ||= label
      end
    end
  end
end
