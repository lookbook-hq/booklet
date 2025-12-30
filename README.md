# Booklet

A work-in-progress, experimental new parser-analyzer engine for [Lookbook](https://lookbook.build).

> [!WARNING]
> Booklet is in a very early stage of development and is **not ready for public use.**<br>It is currently incomplete and will likely see many breaking changes before a stable release candidate is available.

## Overview

Booklet has been created to provide a **standalone, extendable parser-analyzer engine for Lookbook** that can be used as a robust foundation for future versions as well as for potential new tools such as a Lookbook CLI or MCP server.

### Aims and objectives

* Use common, tried-and-tested parser/analyzer implementation patterns over custom workflows where possible.
* Implement the analyzing process as a series of small, incremental steps to aid comprehension and testabilty.
* Be backwards compatable with existing Lookbook parser behaviour as surfaced in the app (although underlying APIs and conceptual definitions may differ).
* Make it straightforward to customise and extend the processing pipeline using plugins/middleware.
* Minimise any 'special-casing' of core functionality over that provided by third party extensions.
* Do not have any dependency on Rails (outside of conveniences provided by the `ActiveSupport` gem).

## Installation

Booklet is both a command line tool and a library.

### CLI interface

To use the booklet CLI you can install the gem globally:

```sh
gem install lookbooklet
```

You can then view the available booklet CLI commands using:

```sh
booklet -h
```

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

## Key Concepts

> _Details coming soon._

## Architecture

> _Details coming soon._

## Testing

Booklet uses Minitest for its test framework.

Run the tests: 

```sh
bin/test
```

<br>

---

## Additional background info

> [!IMPORTANT]
> The details below refer to the way files are handled in the current (v2.x) version of Lookbook.<br>
> Booklet will bring significant changes to this process.

### Overview of file parsing/analyzing in Lookbook 

Lookbook works by inspecting a directory of files, identifying those which are of interest (primarily [component preview files](https://lookbook.build/guide/previews) and Markdown-based [documentation pages](https://lookbook.build/guide/pages)) and then parsing their contents to extract any relevant data.

Lookbook extracts data from annotations within component preview files using the [YARD parser](https://yardoc.org/), extended with additional Lookbook-specific custom tag definitions. Markdown-based documentation pages use the standard Ruby YAML parser to extract data from frontmatter sections, where provided.

Both the data obtained from parsing the file and the location of the file relative to its root directory are important to Lookbook. The organisational hierarchy of files and folders within the root directory is reflected in the Lookbook navigation structure and is used to map requests to target entities in controller actions within the app.

To facilitate this, the current implementation builds up a collection of nested entity objects using a combination of data from the parsed files, the relative paths of the files themselves and other bits of file metadata.


### Why is a new parser engine needed?

The current file parser-analyzer implementation in Lookbook is rather convoluted, hard to understand and does not allow for any modification of the underlying data by plugins (or via middleware of any sort).

It can be slow when dealing with a large number of files, does not have good test coverage and has many unintentional and undocumented quirks.

The 'collection of nested objects' that is eventually generated is _tree-like_ in structure but is not formally defined as a tree of any kind. The objects do not have a consistent structure and this means the collection cannot be easily traversed or transformed without detailed knowlege of the makeup of all the objects within it. This in turn has resulted in a 'bespoke', overly complex underlying data model that can be difficult to make changes to without introducing hard-to-spot bugs caused by unintended consequences of the updates.
