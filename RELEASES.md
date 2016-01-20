# Release History

## v0.2.2 (20 January 2016)
* Add rudimentary support for stillborn mutants
* Better error reporting during mutant generation
* Reduce chance that irrelevant subjects are selected for mutation

## v0.2.1 (20 August 2015)
* Fix [#1](https://github.com/mutiny/mutiny/issues/1) - "Uninitialized constant" exception for all commands

## v0.2.0 (14 August 2015)
* Implement `mutiny score` mode which performs mutation analysis

## v0.1.0 (5 June 2015)
Provide support for:
* Running mutation testing commands via the `mutiny` binary
* Checking that a program is amenable to mutation testing
* Generating mutants using traditional method-level operators
* Integration with RSpec 3
