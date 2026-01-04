module Demo
  module Layouts
    class SyntaxErrorPreview < Lookbook::Preview
      def default
        render html: "this file has a syntax error in it"
      end
    ends
  end
end
