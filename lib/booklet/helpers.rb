# frozen_string_literal: true

module Booklet
  module Helpers
    def strip_indent(value)
      value.to_s.gsub(/^#{value.scan(/^[ \t]*(?=\S)/).min}/, "").strip
    end

    def strip_whitespace(value)
      value.to_s.strip
    end

    def hexdigest(str)
      Digest::MD5.hexdigest(str.to_s)[0..6] if str.present?
    end

    extend self
  end
end
