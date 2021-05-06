# jael
[![Pub](https://img.shields.io/pub/v/jael.svg)](https://pub.dartlang.org/packages/jael)
[![build status](https://travis-ci.org/galileo-dart/jael.svg)](https://travis-ci.org/galileo-dart/jael)

A simple server-side HTML templating engine for Dart.

Though its syntax is but a superset of HTML, it supports features such as:
* **Custom elements**
* Loops
* Conditionals
* Template inheritance
* Block scoping
* `switch` syntax
* Interpolation of any Dart expression

Jael is a good choice for applications of any scale, especially when the development team is small,
or the time invested in building an SPA would be too much.

## Documentation
Each of the [packages within this repository](#this-repository) contains
some sort of documentation.

Documentation for Jael syntax and directives has been
**moved** to the
[galileo framework wiki](https://docs.galileo-dart.dev/packages/front-end/jael).

## This Repository
Within this repository are three packages:

* `package:jael` - Contains the Jael parser, AST, and HTML renderer.
* `package:jael_preprocessor` - Handles template inheritance, and facilitates the use of "compile-time" constructs.
* `package:build_jael` - Uses `package:build` to compile Jael templates, therefore allowing speedy incremental builds to HTML files.
* `package:galileo_jael` - [galileo](https://galileo-dart.github.io) support for Jael. galileo contains other
facilities to speed up application development, so something like Jael is right at home.
