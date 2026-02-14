# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Booklet (gem name: `lookbooklet`) is a standalone Ruby parser-analyzer engine for Lookbook. It generates traversable tree structures of entity nodes from input directories of files (preview classes, markdown pages, assets) via a multi-step processing pipeline using the visitor pattern.

Ruby >= 3.2 required. No Rails dependency (uses ActiveSupport/ActiveModel only).

## Commands

```bash
# Setup
bundle install

# Run all tests
mise test

# Run a single test file
rake test TEST=test/nodes/spec_node_test.rb

# Watch mode (requires mise + watchexec)
mise test:watch             # alias: mise tw

# Lint
bundle exec standard        # check
bundle exec standard --fix  # autofix
```

## Architecture

### Core Pipeline

The system processes files in two phases:

1. **Tree creation** — `EntityLoader` visitor recursively scans a directory and builds a tree of typed `Node` objects
2. **Tree mutation** — A chain of visitors transforms/augments the tree (parse classes, extract metadata, validate, etc.)

Entry point: `Booklet.analyze(path, loader:, visitors:)` → returns an `EntityTree`

### Node Hierarchy

All nodes extend `Booklet::Object` (which extends `Literal::Object` for typed properties).

- `Node` — base class (includes `Enumerable`, `Comparable`, parent/children tree traversal)
- `FolderNode` — directories
- `SpecNode` — preview classes (`*_preview.rb` or `*_booklet.rb`)
- `ScenarioNode` — individual scenarios (public methods within a spec)
- `PageNode` — markdown files
- `ProseNode` — text content within specs
- `AssetNode` — static assets
- `FileNode` — generic/unknown files

Node behaviors are composed via concerns in `lib/booklet/nodes/concerns/`: `Locatable`, `Nameable`, `Hideable`, `AcceptsParams`, `AcceptsDisplayOptions`.

### Visitor Pattern (Double-Dispatch)

Visitors extend `Booklet::Visitor` and implement `visit <NodeType> do |node|` blocks. Key visitors:

- `EntityLoader` — creates tree from filesystem
- `PreviewClassParser` — parses Ruby preview classes using YARD
- `YardTagsHandler` — processes YARD tags (`@param`, `@display`, `@hidden`, `@label`)
- `FrontmatterExtractor` — extracts YAML frontmatter from markdown pages
- `ScenarioGrouper` — groups scenarios
- `RubyValidator` / `HerbValidator` — syntax validation
- `IssueAggregator` — collects issues from the tree
- `HashConverter` / `AsciiTreeRenderer` — output formatters

### Key Dependencies

- **Literal** (`~> 1.8`) — typed property definitions (`prop :name, String`)
- **Zeitwerk** (`~> 2.7`) — autoloading with collapsed namespaces
- **YARD** (`~> 0.9`) — Ruby source parsing, custom tag definitions in `lib/booklet/yard/`
- **ActiveSupport/ActiveModel** (`>= 7.2`) — core extensions, callbacks, concerns

### Testing

Minitest with `shoulda-context` for `context`/`should` syntax. Test fixtures live in `test/fixtures/` with helpers in `test/support/fixtures.rb`. Tests mirror the lib structure under `test/nodes/` and `test/visitors/`.

### CI

GitHub Actions tests against Ruby 3.2, 3.3, 3.4, and 4.0.
