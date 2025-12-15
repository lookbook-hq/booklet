require "literal"
require "active_support"
require "active_support/core_ext"
require "lookbook/manifest/version"

module Lookbook
  module Manifest
    class << self
      def version
        VERSION
      end
    end
  end
end
