require "zeitwerk"
require "lookbook/manifest"

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lookbook", namespace: Lookbook)
loader.collapse("#{__dir__}/lookbook/manifest/**/*")
loader.ignore("#{__dir__}/lookbook/{version}.rb")
loader.setup
