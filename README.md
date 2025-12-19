# Booklet

An experimental new parser engine for [Lookbook](https://lookbook.build).

> [!WARNING]
> _Booklet is at a very early stage of development and is not yet ready for public use!_

## Background info

### Filesystem parsing in Lookbook

[Lookbook](https://lookbook.build) is based on a filesystem parser that takes a directory of files and generates a tree of entity objects from them. These entities each represent a key concept in Lookbook such as a [component preview](https://lookbook.build/guide/previews) or a [documentation page](https://lookbook.build/guide/pages).

The data used to initialize each entity object is derived from a mix of file metadata and from data extracted via static analysis (parsing) of its contents. The hierarchy of entities within the trees is broadly reflective of the nested structure of the files and folders that were used to construct them.

### Issues with the current implementation 😩

Unfortunately the existing implementation of this parsing process is **rather convoluted, hard to understand & reason about and does not allow for any modification of the underlying data** by plugins (or via middleware of any sort).

 The current parser is also quite slow when dealing with a large number of files, does not have good test coverage and has many unintentional and undocumented quirks.

 The overly complex nature of the current implementation means that it is very hard to make changes to the code without breaking things. This is obviously not a great setup for trying to encourage community contributions either.

### A fresh start: Booklet

The aim of the Booklet project is to create a completely new parser engine for Lookbook, designed to address the issues outlined above and to serve as a strong, well-tested foundation for future versions of Lookbook to build upon.

## The Booklet parser pipeline

_More details coming soon..._
