# twig_dart
[![Pub](https://img.shields.io/pub/v/twig.svg)](https://pub.dartlang.org/packages/twig_dart)
[![build status](https://travis-ci.org/galileo-dart/twig.svg)](https://travis-ci.org/insinfo/twig_dart)

A simple server-side HTML templating engine for Dart.

Though its syntax is but a superset of HTML, it supports features such as:
* **Custom elements**
* Loops
* Conditionals
* Template inheritance
* Block scoping
* `switch` syntax
* Interpolation of any Dart expression

twig is a good choice for applications of any scale, especially when the development team is small,
or the time invested in building an SPA would be too much.

## Documentation
Each of the [packages within this repository](#this-repository) contains
some sort of documentation.

Documentation for twig syntax and directives has been
**moved** to the
[galileo framework wiki](https://docs.galileodart.com/packages/front-end/twig).

## This Repository
Within this repository are three packages:

* `package:twig` - Contains the twig parser, AST, and HTML renderer.
* `package:twig_preprocessor` - Handles template inheritance, and facilitates the use of "compile-time" constructs.
* `package:build_twig` - Uses `package:build` to compile twig templates, therefore allowing speedy incremental builds to HTML files.
* `package:galileo_twig` - [galileo](https://galileo-dart.github.io) support for twig. galileo contains other
facilities to speed up application development, so something like twig is right at home.
