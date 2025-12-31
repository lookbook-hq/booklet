module Demo
  module Layouts
    class LandingPagePreview < Lookbook::Preview
      def default
        render "layouts/landing_page" do
          "Welcome!"
        end
      end
    end
  end
end
