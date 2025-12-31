module Demo
  module Elements
    class ButtonComponentPreview < Lookbook::Preview
      def default
        render ButtonComponent.new
      end

      def secondary
        render ButtonComponent.new(theme: :secondary)
      end

      def danger
        render ButtonComponent.new(theme: :danger)
      end
    end
  end
end
