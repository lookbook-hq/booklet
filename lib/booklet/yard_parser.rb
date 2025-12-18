require "yard"

module Booklet
  class YardParser < Booklet::Object
    def initialize(log_level: YARD::Logger::ERROR)
      @log_level = log_level
    end

    def parse(*path_sets)
      paths = Array.wrap(path_sets).flatten.map(&:to_s)

      YARD::Logger.instance.enter_level(@log_level) do
        YARD.parse(paths)
      end

      YARD::Registry.all(:class).filter { paths.include?(_1.file) }
    end

    def parse_file(path)
      parse(path).first
    end
  end
end
