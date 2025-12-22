require "support/test_helper"

module Booklet
  class AsciiTreeRendererTest < Minitest::Test
    include FixtureHelpers

    context "the transformer" do
      setup do
        @root_path = fixture_file("entities")
        @files = DirectoryNode.new("entities", path: @root_path).accept(FilesystemLoader.new)
      end

      should "render an ascii tree" do
        ascii_tree = @files.accept(AsciiTreeRenderer.new)

        expected = <<~TREE
          entities
          ├── a
          │   ├── a.config.yml
          │   └── aa
          │       ├── aaa_preview
          │       │   └── default.html.erb
          │       ├── aaa_preview.rb
          │       └── aab_component_preview.rb
          ├── b
          │   ├── about.the.poignant.guide-1.png
          │   └── not_a_preview.txt
          ├── blix-neg.gif
          ├── c
          │   ├── 1.chunky.md
          │   ├── 2.bacon.md.erb
          │   ├── README.md
          │   └── styles.css
          └── empty_folder
        TREE

        assert_equal expected.strip, ascii_tree
      end
    end
  end
end
