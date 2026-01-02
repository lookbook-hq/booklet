# Booklet

A WIP new standalone, extendable **parser-analyzer engine** for [Lookbook](https://lookbook.build).

The aim is for Booklet to eventually replace the existing file parsing/analyzing code in Lookbook and thus provide a more robust foundation for future releases to build upon.

Additionally, Booklet is being developed as a standalone gem in part so that it can also be used as a springboard for building additional tools (CLIs, MCP servers etc) to help Lookbook integrate more seamlessly into a variety of Rails frontend development workflows.

> [!WARNING]
> Booklet is in a very early stage of development and is **not ready for public use.**<br>It is currently incomplete and will likely see many breaking changes before a stable release candidate is available.

## Aims and objectives

* Use common, tried-and-tested parser/transformer implementation patterns over custom workflows where possible.
* Implement the analyzing process as a series of small, incremental steps to aid comprehension and testabilty.
* Be backwards compatable with existing Lookbook parser behaviour as surfaced in the app (although underlying APIs and conceptual definitions may differ).
* Make it straightforward to customise and extend the processing pipeline using plugins/middleware.
* Minimise any 'special-casing' of core functionality over that provided by third party extensions.
* Do not have any dependency on Rails (outside of conveniences provided by the `ActiveSupport` gem).

## Development status

Booklet is a brand new project and is not yet ready for public use. 

The [issues list](https://github.com/lookbook-hq/booklet/issues) contains an (incomplete) set of work that is planned before an initial beta release will be made available. 

Issues specifically related to achieving compatability with Lookbook's current parser output are tagged with the `compatability` label and the [Lookbook compatability](https://github.com/orgs/lookbook-hq/projects/3) project board has been set up to track progress on this metric.

## Why is a new parser engine needed?

The first incarnation of Lookbook was just a simple set of view templates that made it easier to navigate around ViewComponent previews within a Rails app. It effectively delegated handling of everything else to the native ViewComponent preview system, which itself is fairly bare-bones, so there was no need for analyzing files or anything like that.

Lookbook progressed organically from that point into the much more general-purpose tool it is today, slowly adding features and functionality. Many of the new features _did_ require some file parsing and analysis so those steps were tacked on to the existing codebase, and now we are at a place where the parser-analyzer logic is really right at the core of how Lookbook works.

But the system was never really designed around the idea of it being a filesytem-based parser-analyzer pipeline. The consequences of this include:

* The codebase is much too convoluted and hard to understand, and it is difficult to track down where many of the processing steps actually take place. It's a black box.
* The system does not allow for any modification of the underlying data by plugins (or via middleware of any sort).
* It can be slow when dealing with a large number of files.
* It does not have good test coverage and has many unintentional and undocumented quirks.

Booklet has been created to address these issues (and many others) by implementing a 'proper' parser-analyzer pipeline that is designed from the ground-up to cater for Lookbook's current requirements and to act as a flexible foundation for building future functionality on top of.

## Implementation details

Booklet generates a **traversable tree of entity node objects** from an input directory of files, via a number of intermediate steps.

Trees can contain a number of different node types. These include **folder nodes**, **file-based entity nodes** and entity **child nodes** that represent the contents of key resource types.

The hierarchy of the nodes in the tree broadly reflects the grouping of input files into folders and subfolders within the root directory as well as parent-child entity-content relationships where present.

All tree mutations and transformations are performed by ['double dispatch'-style](https://www.bigbinary.com/blog/visitor-pattern-and-double-dispatch) **node visitors**.

### File processing pipeline

Booklet breaks up the processing of files into four steps:

1. File tree creation
2. File tree mutation
3. File tree &rarr; entity tree transformation
4. Entity tree mutation
  
#### 1. File tree creation

In the first step a tree of generic file and directory nodes is constructed by recursively scanning the root directory and adding a node for every file and folder found. This is handled by the [`FilesystemLoader` visitor](./lib/booklet/visitors/filesystem_loader.rb).

```ruby
file_tree = DirectoryNode.from("test/fixtures/demo").accept(FilesystemLoader.new)
```

<details>
<summary>Resulting file tree</summary>

> _ASCII tree visualisation generated using the [`AsciiTreeRenderer` visitor](./lib/booklet/visitors/ascii_tree_renderer.rb)_

```
 [DirectoryNode] demo
 ├── [DirectoryNode] docs
 │   ├── [FileNode] _tmp_notes.txt
 │   ├── [FileNode] banner.png
 │   ├── [FileNode] overview.md
 │   ├── [FileNode] resources.md
 │   └── [DirectoryNode] usage
 │       ├── [FileNode] getting_started.md
 │       ├── [FileNode] installation.md
 │       └── [FileNode] screenshot.svg
 └── [DirectoryNode] view_specs
     ├── [DirectoryNode] elements
     │   ├── [FileNode] button_component_spec.rb
     │   └── [FileNode] card_component_spec.rb
     ├── [FileNode] helpers_spec.rb
     └── [DirectoryNode] layouts
         ├── [FileNode] article_spec.rb
         └── [FileNode] landing_page_spec.rb
```
</details>

#### 2. File tree mutation

This is an optional step where additional node visitors can be provided to mutate the file tree before it is handed off to the entity transformer.

For example you might want to create a custom Visitor class that removes all files with names beginning with an underscore (such as `_tmp_notes.txt` in the example above) to clean up the tree before the entity transformer is run.

```ruby
file_tree.accept(SomeCustomFileTreeProcessor.new)
```

#### 3. File tree &rarr; Entity tree transformation

In this step the [`EntityTransformer`](./lib/booklet/visitors/entity_transformer.rb) visitor is applied to the raw file tree. The transformer visits each of the generic file/directory nodes in the file tree and converts all 'recognized' file types to their corresponding Lookbook entity node type.

For example, files with `.md` extensions are transformed into `DocumentNode` instances, whilst component preview class files (names ending in `_preview.rb`) are transformed into `SpecNode` instances.

```ruby
entity_tree = file_tree.accept(EntityTransformer.new)
```

<details>
<summary>Resulting entity tree</summary>

```
 [FolderNode] Demo
 ├── [FolderNode] Docs
 │   ├── [AnonNode] _tmp_notes.txt
 │   ├── [AssetNode] banner.png
 │   ├── [DocumentNode] Overview
 │   ├── [DocumentNode] Resources
 │   └── [FolderNode] Usage
 │       ├── [DocumentNode] Getting Started
 │       ├── [DocumentNode] Installation
 │       └── [AssetNode] screenshot.svg
 └── [FolderNode] Previews
     ├── [FolderNode] Elements
     │   ├── [SpecNode] Button Component Preview
     │   └── [SpecNode] Card Component Preview
     ├── [SpecNode] Helpers Preview
     └── [FolderNode] Layouts
         ├── [SpecNode] Article Preview
         └── [SpecNode] Landing Page Preview
```
</details>


#### 4. Entity tree mutation

This final step is where enity node visitors can be applied to perform tasks such as parsing file contents and generally 'building out' the skeleton entity node objects created in the previous step. 

By default Booklet will apply the [`PreviewClassParser`](./lib/booklet/visitors/preview_class_parser.rb) and [`FrontmatterExtractor`](./lib/booklet/visitors/frontmatter_extractor.rb) visitors at this stage.

```ruby
entity_tree
  .accept(PreviewClassParser.new)
  .accept(FrontMatterExtractor.new)
```

* The `PreviewClassParser` visitor uses the [YARD parser](https://yardoc.org/) to extract annotations data from preview class files and creates and appends corresponding `ScenarioNode` and `ProseNode` children to the appropriate `SpecNode` instance.
* The `FrontmatterExtractor` visitor _(not yet implemented!)_ extracts YAML-formatted 'frontmatter' from the contents of markdown files and updates the related `DocumentNode` instances with the parsed data.

Additional entity node vistors can be applied here as needed to make changes to the entity tree nodes before the finalised entity tree is returned for use by the calling code. 

<details>
<summary>Final entity tree</summary>

_Note that the `docs` branch has been omitted for brevity._

```
...
└── [FolderNode] Previews
    ├── [FolderNode] Elements
    │   ├── [SpecNode] Button Component Preview
    │   │   ├── [ScenarioNode] Default
    │   │   ├── [ScenarioNode] Secondary
    │   │   └── [ScenarioNode] Danger
    │   └── [SpecNode] Card Component Preview
    │       ├── [ScenarioNode] No Title
    │       └── [ScenarioNode] With Title
    ├── [SpecNode] Helpers Preview
    │   ├── [ScenarioNode] Blah Generator
    │   └── [ScenarioNode] Char Tag Wrapper
    └── [FolderNode] Layouts
        ├── [SpecNode] Article Preview
        │   └── [ScenarioNode] Default
        └── [SpecNode] Landing Page Preview
            └── [ScenarioNode] Default
```

</details>

## Installation

> [!IMPORTANT]
> Booklet is not yet ready for public use - these instructions are for illustrative purposes only at this point.
> See the [Development status](#development-status) section for more info.

Booklet is both a **command line tool** and a **library**.

### Using as a dependency

Add Booklet to your Gemfile:

```ruby
gem "lookbooklet"
```

After running `bundle install` you can then make use of the Booklet API in your codebase:

```ruby
require "lookbooklet"

result = Booklet.analyze("path/to/root/directory")
```

### CLI interface

To use the booklet CLI you can install the gem globally:

```sh
gem install lookbooklet
```

You can then view the available booklet CLI commands using:

```sh
booklet -h
```

## API

> _Details coming soon._


## Testing

Booklet uses Minitest for its test framework.

Run the tests: 

```sh
bin/test
```

## Acknowlegments

[Marco Roth](https://marcoroth.dev/)'s fantastic work on [Herb](https://herb-tools.dev/) (and my subsequent deep-dive into the world of ASTs) was been instrumental in sparking the initial idea for Booklet and for shaping its approach.

Booklet's double-dispatch style node visitor base class is based on the very nice [BasicVisitor](https://github.com/yippee-fun/refract/blob/main/lib/refract/basic_visitor.rb) class from the [Refract gem](https://github.com/yippee-fun/refract). 

In addition much of the original incarnation of Booklet's `Node` class was based on code adapted from the excellent [RubyTree](https://github.com/evolve75/RubyTree) gem.
