module Booklet
  module Nameable
    extend ActiveSupport::Concern

    included do
      prop :name, String, reader: :public, writer: :public do |value|
        value.to_s
      end

      prop :label, _String?, writer: :public
      prop :title, _String?, writer: :public

      def label = @label ||= name.titleize

      def title = @title ||= label
    end
  end
end
