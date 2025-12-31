module Demo
  module Elements
    class CardComponentPreview < Lookbook::Preview
      def no_title
        render CardComponent.new do |card|
          "Example card content"
        end
      end

      def with_title
        render CardComponent.new do |card|
          card.with_title do
            "Example card title"
          end

          "Example card content"
        end
      end
    end
  end
end
