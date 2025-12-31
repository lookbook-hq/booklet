module Demo
  class HelpersPreview < Lookbook::Preview
    def blah_generator
      Demo::Helpers.generate_blahs(12)
    end

    def char_tag_wrapper
      Demo::Helpers.wrap_each_char_with_tag("hello", :span)
    end
  end
end
