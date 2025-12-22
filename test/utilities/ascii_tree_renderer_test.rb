require "support/test_helper"

module Booklet
  class AsciiTreeRendererTest < Minitest::Test
    include FixtureHelpers

    context "ascii tree renderer" do
      setup do
        @root_path = fixture_file("entities")
        @files = DirectoryNode.new("entities", path: @root_path).accept(FilesystemLoader.new)
      end

      context "default" do
        should "render an ascii tree with node names as labels" do
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

      context "with custom label generator" do
        should "render an ascii tree with customised node labels" do
          tree_renderer = AsciiTreeRenderer.new do |node|
            node.file.name.upcase
          end

          ascii_tree = @files.accept(tree_renderer)

          expected = <<~TREE
            ENTITIES
            ├── A
            │   ├── A
            │   └── AA
            │       ├── AAA_PREVIEW
            │       │   └── DEFAULT
            │       ├── AAA_PREVIEW
            │       └── AAB_COMPONENT_PREVIEW
            ├── B
            │   ├── ABOUT
            │   └── NOT_A_PREVIEW
            ├── BLIX-NEG
            ├── C
            │   ├── 1
            │   ├── 2
            │   ├── README
            │   └── STYLES
            └── EMPTY_FOLDER
          TREE

          assert_equal expected.strip, ascii_tree
        end
      end
    end
  end
end
