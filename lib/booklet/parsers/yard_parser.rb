# frozen_string_literal: true

require "yard"

module Booklet
  class YardParser < Booklet::Object
    prop :log_level, Integer, default: ::YARD::Logger::ERROR.freeze

    def parse(*path_sets)
      paths = Array.wrap(path_sets).flatten.map(&:to_s)

      ::YARD::Logger.instance.enter_level(@log_level) do
        ::YARD.parse(paths)
      end

      ::YARD::Registry.all(:class).filter do |code_object|
        paths.include?(code_object.file)
      end
    end

    def parse_file(path)
      parse(path).first
    end

    class << self
      def define_tags(tags)
        tags = tags.map { _1.is_a?(String) ? _1.constantize : _1 }
        tags.each do |tag|
          ::YARD::Tags::Library.define_tag(tag.label, tag.tag_name, tag)
        end
      end
    end
  end
end
